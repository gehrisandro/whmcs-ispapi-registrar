<?php
## .QUEBEC DOMAIN REQUIREMENTS ##
## remove default whmcs fields ##
$additionaldomainfields[$tld][] = array(
    "Name" => "Info",
    "Remove" => true
);

## add ispapi additional fields ##
include "_intendeduse.php";