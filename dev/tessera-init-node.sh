#!/usr/bin/env bash

echo "[*] Initialising Tessera configuration"

start=$1
end=$2

currentDir=$(pwd)
for i in $(seq "$start" "$end")
do
  DDIR="${currentDir}/qdata/c${i}"
  mkdir -p ${DDIR}
  mkdir -p qdata/logs
  cp "keys/tm${i}.pub" "${DDIR}/tm.pub"
  cp "keys/tm${i}.key" "${DDIR}/tm.key"
  rm -f "${DDIR}/tm.ipc"

  #change tls to "strict" to enable it (don't forget to also change http -> https)
  cat <<EOF > ${DDIR}/tessera-config-10-${i}.json
{
    "useWhiteList": false,
    "jdbc": {
        "username": "sa",
        "password": "",
        "url": "jdbc:h2:${DDIR}/db${i};MODE=Oracle;TRACE_LEVEL_SYSTEM_OUT=0",
        "autoCreateTables": true
    },
    "serverConfigs":[
        {
            "app":"ThirdParty",
            "enabled": true,
            "serverAddress": "http://localhost:908${i}",
            "communicationType" : "REST"
        },
        {
            "app":"Q2T",
            "enabled": true,
            "serverAddress":"unix:${DDIR}/tm.ipc",
            "communicationType" : "REST"
        },
        {
            "app":"P2P",
            "enabled": true,
            "serverAddress":"http://localhost:900${i}",
            "sslConfig": {
                "tls": "OFF",
                "generateKeyStoreIfNotExisted": true,
                "serverKeyStore": "${DDIR}/server${i}-keystore",
                "serverKeyStorePassword": "quorum",
                "serverTrustStore": "${DDIR}/server-truststore",
                "serverTrustStorePassword": "quorum",
                "serverTrustMode": "TOFU",
                "knownClientsFile": "${DDIR}/knownClients",
                "clientKeyStore": "${DDIR}/client${i}-keystore",
                "clientKeyStorePassword": "quorum",
                "clientTrustStore": "${DDIR}/client-truststore",
                "clientTrustStorePassword": "quorum",
                "clientTrustMode": "TOFU",
                "knownServersFile": "${DDIR}/knownServers"
            },
            "communicationType" : "REST"
        }
    ],
    "peer": [
        {
            "url": "http://localhost:9001"
        },
        {
            "url": "http://localhost:9002"
        },
        {
            "url": "http://localhost:9003"
        },
        {
            "url": "http://localhost:9004"
        },
        {
            "url": "http://localhost:9005"
        },
        {
            "url": "http://localhost:9006"
        },
        {
            "url": "http://localhost:9007"
        }
    ],
    "keys": {
        "passwords": [],
        "keyData": [
            {
                "privateKeyPath": "${DDIR}/tm.key",
                "publicKeyPath": "${DDIR}/tm.pub"
            }
        ]
    },
    "alwaysSendTo": []
}
EOF

  # Enclave configurations
  cat <<EOF > ${DDIR}/tessera-config-enclave-10-${i}.json
{
    "useWhiteList": false,
    "jdbc": {
        "username": "sa",
        "password": "",
        "url": "jdbc:h2:${DDIR}/db${i};MODE=Oracle;TRACE_LEVEL_SYSTEM_OUT=0",
        "autoCreateTables": true
    },
    "serverConfigs":[
        {
            "app":"ENCLAVE",
            "enabled": true,
            "serverAddress": "http://localhost:918${i}",
            "communicationType" : "REST"
        },
        {
            "app":"ThirdParty",
            "enabled": true,
            "serverAddress": "http://localhost:908${i}",
            "communicationType" : "REST"
        },
        {
            "app":"Q2T",
            "enabled": true,
             "serverAddress":"unix:${DDIR}/tm.ipc",
            "communicationType" : "REST"
        },
        {
            "app":"P2P",
            "enabled": true,
            "serverAddress":"http://localhost:900${i}",
            "sslConfig": {
                "tls": "OFF"
            },
            "communicationType" : "REST"
        }
    ],
    "peer": [
        {
            "url": "http://localhost:9001"
        },
        {
            "url": "http://localhost:9002"
        },
        {
            "url": "http://localhost:9003"
        },
        {
            "url": "http://localhost:9004"
        },
        {
            "url": "http://localhost:9005"
        },
        {
            "url": "http://localhost:9006"
        },
        {
            "url": "http://localhost:9007"
        }
    ]
}
EOF

  cat <<EOF > ${DDIR}/enclave-10-${i}.json
{
    "serverConfigs":[
        {
            "app":"ENCLAVE",
            "enabled": true,
            "serverAddress": "http://localhost:918${i}",
            "communicationType" : "REST"
        }
    ],
    "keys": {
        "passwords": [],
        "keyData": [
            {
                "privateKeyPath": "${DDIR}/tm.key",
                "publicKeyPath": "${DDIR}/tm.pub"
            }
        ]
    },
    "alwaysSendTo": []
}
EOF

done
