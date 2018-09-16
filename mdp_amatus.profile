<?php

/**
 * @file
 * Enables modules and site configuration for a Amatus site installation.
 */

use Drupal\Core\Form\FormStateInterface;

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
