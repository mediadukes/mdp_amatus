<?php

namespace Drupal\mdp_amatus\Controller;

use Drupal\Core\Controller\ControllerBase;

/**
 * Class AmatusController.
 *
 * @package Drupal\mdp_amatus\Controller
 */
class AmatusController extends ControllerBase {

  /**
   * The custom homepage.
   */
  public function content() {
    return array(
      '#type' => 'markup',
      '#markup' => $this->t('Welcome to this new website!'),
    );
  }

}
