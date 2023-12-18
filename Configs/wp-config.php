<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/documentation/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wordpress' );

/** Database password */
define( 'DB_PASSWORD', 'Vz7,4*,4C3Y7' );

/** Database hostname */
define( 'DB_HOST', '%' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );


/** Direct Database Connection */
@mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);


/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '4^*;gYe@h>iOHX/Q8YwJ[F{h)Wq@!n%76uWqcjjUrH-+udb2B[OrB*8$(>M}78II');
define('SECURE_AUTH_KEY',  '5SI@(M+l]}GU|u3*m1;zWV5Cw3y#g<H3T2s%-ydT_|Xt3!1m {k)D&mLU+ G/FOH');
define('LOGGED_IN_KEY',    'Z%-oXcX2`TDK}xV.DOq]^`41juCRi4tzA}^#+OvllHl4#p|X)/ u-~!K$}O}sVyW');
define('NONCE_KEY',        '^f}0|qU4+%-%`dA2>%^HWMBUeOVWyR>fQ9Om-b0>kin)mHl7SDLIm7em|aaAc9[Z');
define('AUTH_SALT',        'jSewMFUv{5q`|/.+1@upg5GAmt;-.~N0wO$${Yp{/)M%_iH_.LGg>v|Mj2&Ii>EQ');
define('SECURE_AUTH_SALT', '@]1~{mpNVaMm{0p!qA4V8Q!%2RXx:#>J6+u;2psy~4X-:4s;dxrte7j<UUYu.WwL');
define('LOGGED_IN_SALT',   'iyc+jAF5(X95FkYqg{|6>T7%kQ=;3LD>k!1Gv[HE!>)Cdk%|P>w)E/wg=4G+(<d/');
define('NONCE_SALT',       'T4fU0<WU(289+6DpqhQT+!=6oTo<f{K;x tOE`0@z#2[jc1~#-RoN::5-(+w?Cr|');

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/documentation/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
