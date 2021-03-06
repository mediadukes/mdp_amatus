# Amatus: custom Drupal 8 install profile

This profile can be used to kickstart new Drupal 8 projects. It automatically installs and configures a bunch of useful modules and themes.

Some key modules/themes are:

- [config_split](https://www.drupal.org/project/config_split)
- [google_analytics](https://www.drupal.org/project/google_analytics)
- [metatag](https://www.drupal.org/project/metatag)
- [simple_sitemap](https://www.drupal.org/project/simple_sitemap)
- [pathauto](https://www.drupal.org/project/pathauto)
- [linkit](https://www.drupal.org/project/linkit)
- [adminimal_admin_toolbar](https://www.drupal.org/project/adminimal_admin_toolbar)
- [adminimal_theme](https://www.drupal.org/project/adminimal_theme)

This profile also adds 2 content types (article and basic page) which uses paragraphs fields to add content. For a set of pre-configured paragraph types this profile uses the [mdm_paragraphs](https://github.com/mediadukes/mdm_paragraphs) module.
Custom block types are available through the [mdm_blocks](https://github.com/mediadukes/mdm_blocks) module.
Some theming improvements to the the adminimal theme are added via the [mdt_adminimal](https://github.com/mediadukes/mdt_adminimal) subtheme.


## Usage

Just install as any other drupal profile using `composer require`.

```
composer require mediadukes/mdp_amatus:^1.0
```

If it's not already present in your repositories array you'll need to define inside your root `composer.json` where mediadukes packages can be found.

```
"repositories": [
  {
    "type": "composer",
    "url": "https://packages.mediadukes.be"
  }
]
```

Or you can use the [mediadukes drupal-project template](https://github.com/mediadukes/drupal-project) where all of this is already added.
