<?php
	/**
	 * @author: Tấn Việt
	 * @website: https://tanvietblog.com
	 * @description: This script will get IP address of visitors
	 * @copyright 2013
	 */

	$ip = $_SERVER['REMOTE_ADDR'];

    if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
        $ip = $_SERVER['HTTP_CLIENT_IP'];
    } else if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
    }

	echo "IP address: " . $ip;
?>