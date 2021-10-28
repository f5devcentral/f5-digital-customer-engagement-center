{
    "schemaVersion": "1.0.0",
    "class": "Device",
    "async": true,
    "label": "Onboard BIG-IP",
    "Common": {
        "class": "Tenant",
        "mySystem": {
            "class": "System",
            "hostname": "${hostname}"
        },
        "myDns": {
            "class": "DNS",
            "nameServers": [
                    ${name_servers}
            ],
            "search": [
                "f5.com"
            ]
        },
        "myNtp": {
            "class": "NTP",
            "servers": [
                    ${ntp_servers}
            ],
            "timezone": "UTC"
        }
    }
}
