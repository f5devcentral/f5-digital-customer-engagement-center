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
    },
    "${vlan-name1}": {
      "class": "VLAN",
      "tag": 4093,
      "mtu": 1500,
      "interfaces": [
        {
          "name": "1.1",
          "tagged": false
        }
      ],
      "cmpHash": "dst-ip"
    },
    "${vlan-name1}-self": {
      "class": "SelfIp",
      "address": "${self-ip1}/24",
      "vlan": "${vlan-name1}",
      "allowService": "none",
      "trafficGroup": "traffic-group-local-only"
    },
    "default": {
      "class": "Route",
      "gw": "${gateway}",
      "network": "default",
      "mtu": 1500
    },
    "${vlan-name2}": {
      "class": "VLAN",
      "tag": 4094,
      "mtu": 1500,
      "interfaces": [
        {
          "name": "1.2",
          "tagged": false
        }
      ],
      "cmpHash": "dst-ip"
    },
    "${vlan-name2}-self": {
      "class": "SelfIp",
      "address": "${self-ip2}/24",
      "vlan": "${vlan-name2}",
      "allowService": "default",
      "trafficGroup": "traffic-group-local-only"
    }
  }
}
