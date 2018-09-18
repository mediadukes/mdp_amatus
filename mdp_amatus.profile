<?php

/**
 * @file
 * Enables modules and site configuration for a Amatus site installation.
 */

use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Config\FileStorageFactory;
use Drupal\config_filter\Config\FilteredStorage;
use Drupal\config_split\Config\GhostStorage;

/**
 * Implements hook_form_FORM_ID_alter() for install_configure_form().
 *
 * Allows the profile to alter the site configuration form.
 */
function mdp_amatus_form_install_configure_form_alter(&$form, FormStateInterface $form_state) {
  // Default site information.
  $form['site_information']['site_name']['#placeholder'] = t('New Media Dukes project');
  $form['site_information']['site_mail']['#default_value'] = 'info@mediadukes.be';

  // Administrator default Account information.
  $form['admin_account']['account']['name']['#default_value'] = 'Superman';
  $form['admin_account']['account']['mail']['#default_value'] = 'webmaster@mediadukes.be';

  // Default Date/time settings.
  $default_country = 'BE';
  $default_timezone = 'Europe/Brussels';
  $form['regional_settings']['site_default_country']['#default_value'] = $default_country;
  $form['regional_settings']['date_default_timezone']['#default_value'] = $default_timezone;

  // Disable email notifications by default.
  $form['update_notifications']['enable_update_status_emails']['#default_value'] = 0;
}

/**
 * Implements hook_install_tasks().
 */
function mdp_amatus_install_tasks() {
  return [
    'mdp_amatus_cleanup' => [
      'display_name' => 'Profile cleanup',
      'display' => FALSE,
      'type' => 'normal',
      'run' => INSTALL_TASK_RUN_IF_NOT_COMPLETED,
    ],
  ];
}

/**
 * Custom function with all the cleanup tasks.
 */
function mdp_amatus_cleanup() {
  // Disable unused views.
  $unused_views = [
    'content_recent',
    'frontpage',
    'who_s_new',
    'who_s_online',
  ];

  foreach ($unused_views as $view_id) {
    $view = \Drupal::entityTypeManager()->getStorage('view')->load($view_id);
    if (!is_null($view)) {
      $view->setStatus(FALSE);
      $view->save();
    }
  }

  // Set new homepage.
  $site_settings = \Drupal::configFactory()->getEditable('system.site');
  $site_settings->set('page.front', '/default-homepage')->save(TRUE);

  // Export all configuration.
  // Register the export as a shutdown function rather than invoking
  // it immediately to allow the profile installation to wrapup cleanly.
  drupal_register_shutdown_function(function () {

    // Get access to the configuration override array.
    global $config;

    // Turn on all the splits temporarily to capture an initial set of configs.
    // Note that for the export to correctly remove a split's "complete split /
    // blacklist" modules from core.extension.yml, the split must be enabled.
    foreach (['local', 'dev', 'test', 'live'] as $split) {
      $key = "config_split.config_split.$split";
      $split_status[$split] = $config[$key]['status'];
      $config[$key]['status'] = TRUE;
    }

    // Export the initial set of this site's configuration files. Note that this
    // function does not export the configs for all active splits as expected.
    // Therefore, we must also manually export the configs for each split.
    // n.b. Reusing the same instance of the config.storage.sync service causes
    // the configs to not export as expected, so don't assign it to a variable
    // and just load the service from the container every time it's needed.
    $config_split = \Drupal::service('config_split.cli');
    $config_split->export(\Drupal::service('config.storage.sync'));

    // Individually export each config split.
    // Code adapted from \Drupal\config_split\ConfigSplitCliService::ioExport().
    $config_filter = \Drupal::service('plugin.manager.config_filter');
    $storage_factory = \Drupal::service('config_filter.storage_factory');
    $sync = FileStorageFactory::getSync();
    foreach (['local', 'dev', 'test', 'live'] as $split) {
      $plugin_id = "config_split:$split";
      $filter = $config_filter->getFilterInstance($plugin_id);
      $storage = $storage_factory->getFilteredStorage($sync, ['config.storage.sync'], [$plugin_id]);
      $split = new FilteredStorage(new GhostStorage($storage), [$filter]);
      $config_split->export($split);
    }

    // Restore the config splits to their original values.
    foreach (['local', 'dev', 'test', 'live'] as $split) {
      $config["config_split.config_split.$split"]['status']
        = $split_status[$split];
    }

    // Rebuild caches to make the config split settings take effect.
    drupal_flush_all_caches();

    // Execute a config import to trigger the Config Split module to tune this
    // environment according to its active split(s). E.g., turn off
    // production-only modules in the dev environment.
    $config_split->import(\Drupal::service('config.storage.sync'));
  });
}
