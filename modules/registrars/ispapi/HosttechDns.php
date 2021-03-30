<?php

namespace WHMCS\Module\Registrar\Hosttech;

use WHMCS\Domain\Domain;
use GuzzleHttp\Client as HttpClient;

if (defined("WHMCS")) {
    if (!function_exists("getregistrarconfigoptions")) {
        require_once implode(DIRECTORY_SEPARATOR, [ROOTDIR, "includes", "registrarfunctions.php"]);
    }
}

class HosttechDns
{
    const recordTypes = [
        'A' => [
            'name' => ['label' => 'Host', 'placeholder' => '@'],
            'ipv4' => ['label' => 'IPv4', 'width' => '200'],
            'ttl' => ['label' => 'TTL', 'placeholder' => '10800', 'width' => '90'],
            'comment' => ['label' => 'Comment', 'placeholder' => 'Comment', 'width' => '150'],
        ],
        'AAAA' => [
            'name' => ['label' => 'Host', 'placeholder' => '@'],
            'ipv6' => ['label' => 'IPv6', 'width' => '200'],
            'ttl' => ['label' => 'TTL', 'placeholder' => '10800', 'width' => '90'],
            'comment' => ['label' => 'Comment', 'placeholder' => 'Comment', 'width' => '150'],
        ],
        'MX' => [
            'ownername' => ['label' => 'Host', 'placeholder' => '@'],
            'name' => ['label' => 'Mail Exchanger'],
            'pref' => ['label' => 'Priority', 'width' => '80'],
            'ttl' => ['label' => 'TTL', 'placeholder' => '10800', 'width' => '90'],
            'comment' => ['label' => 'Comment', 'placeholder' => 'Comment', 'width' => '150'],
        ],
        'CNAME' => [
            'name' => ['label' => 'Host', 'placeholder' => '@'],
            'cname' => ['label' => 'CNAME'],
            'ttl' => ['label' => 'TTL', 'placeholder' => '10800', 'width' => '90'],
            'comment' => ['label' => 'Comment', 'placeholder' => 'Comment', 'width' => '150'],
        ],
        'TXT' => [
            'name' => ['label' => 'Name', 'placeholder' => '@'],
            'text' => ['label' => 'Text'],
            'ttl' => ['label' => 'TTL', 'placeholder' => '10800', 'width' => '90'],
            'comment' => ['label' => 'Comment', 'placeholder' => 'Comment', 'width' => '150'],
        ],
        'CAA' => [
            'name' => ['label' => 'Host', 'placeholder' => '@'],
            'flag' => ['label' => 'Flag'],
            'tag' => ['label' => 'Tag'],
            'value' => ['label' => 'Value'],
            'ttl' => ['label' => 'TTL', 'placeholder' => '10800', 'width' => '90'],
            'comment' => ['label' => 'Comment', 'placeholder' => 'Comment', 'width' => '150'],
        ],
//        'PTR' => [
//            'origin' => ['label' => 'Origin', 'placeholder' => '@'],
//            'name' => ['label' => 'Name'],
//            'ttl' => ['label' => 'TTL', 'placeholder' => '10800', 'width' => '90'],
//            'comment' => ['label' => 'Comment', 'placeholder' => 'Comment', 'width' => '150'],
//        ],
        'SRV' => [
            'service' => ['label' => 'Service', 'placeholder' => '@'],
            'priority' => ['label' => 'Priority', 'width' => '65'],
            'weight' => ['label' => 'Weight', 'width' => '65'],
            'port' => ['label' => 'Port', 'width' => '65'],
            'target' => ['label' => 'Target'],
            'ttl' => ['label' => 'TTL', 'placeholder' => '10800', 'width' => '90'],
            'comment' => ['label' => 'Comment', 'placeholder' => 'Comment', 'width' => '150'],
        ],
        'TLSA' => [
            'name' => ['label' => 'Name', 'placeholder' => '@'],
            'text' => ['label' => 'Text'],
            'ttl' => ['label' => 'TTL', 'placeholder' => '10800', 'width' => '90'],
            'comment' => ['label' => 'Comment', 'placeholder' => 'Comment', 'width' => '150'],
        ],
        'NS' => [
            'ownername' => ['label' => 'Host', 'placeholder' => '@'],
            'targetname' => ['label' => 'Nameserver'],
            'ttl' => ['label' => 'TTL', 'placeholder' => '10800', 'width' => '90'],
            'comment' => ['label' => 'Comment', 'placeholder' => 'Comment', 'width' => '150'],
        ],
    ];

    public static function translate($string, $language)
    {
        return [
                'Comment' => ['de_DE' => 'Kommentar', 'en_GB' => 'Comment'],
                'error' => ['de_DE' => 'Fehler', 'en_GB' => 'Error'],
                'active' => ['de_DE' => 'Aktiv', 'en_GB' => 'Active'],
                'inactive' => ['de_DE' => 'Inaktiv', 'en_GB' => 'Inactive'],
                'dnssec_status_success' => ['de_DE' => 'Zone signiert.', 'en_GB' => 'Zone is signed.'],
                'dnssec_status_registry_ds_record_missing' => ['de_DE' => 'Bei der Domainregistry ist noch kein DS Record hinterlegt.', 'en_GB' => 'There is no DS record stored at the domain registry.'],
                'dnssec_status_registry_ds_record_mismatch' => ['de_DE' => 'Bei der Domainregistry ist kein DS Record passender hinterlegt.', 'en_GB' => 'There is no matching DS record stored at the domain registry.'],
                'dnssec_ds_error_autofix' => ['de_DE' => 'Problem beheben', 'en_GB' => 'Fix problem'],
            ][$string][$language] ?? $string;
    }

    protected static function call($method, $url, $data = null, $auth = true)
    {
        $params = \getregistrarconfigoptions('hosttech');

        $headers = [
            'Accept' => 'application/json'
        ];

        if($auth){
            $headers['Authorization'] = 'Bearer ' . $params['DnsApiToken'];
        }

        $http = new HttpClient([
            'headers' => $headers,
        ]);

        $response = $http->{$method}('https://api.ns1.hosttech.eu/api' . $url,
            [
                'http_errors' => false,
                'json' => $data,
            ]);

        return json_decode($response->getBody(), 1);
    }

    public static function getZone(Domain $domain)
    {
        return self::call('get', '/user/v1/zones/' . $domain->domain)['data'];
    }

    public static function saveZone(Domain $domain, $records)
    {
        return self::call('put', '/user/v1/zones/' . $domain->domain, [
            'records' => $records
        ]);
    }

    public static function getProfile()
    {
        return self::call('get', '/v1/auth/me')['data'];
    }

    public static function createZone($domain, $ttl, $nameserver, $dnssec = false, $records = [])
    {
        return self::call('post', '/user/v1/zones', [
            'name' => $domain->domain,
            'email' => $domain->client->email,
            'ttl' => $ttl,
            'nameserver' => $nameserver,
            'dnssec' => $dnssec,
            'records' => $records
        ])['data'];
    }

    public static function getDnssecStatus(Domain $domain)
    {
        return self::call('get', '/user/v1/zones/' . $domain->domain . '/dnssec_status')['data'];
    }
}
