#!/bin/sh
# Parse arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --debug)
            DEBUG=true
            LOGGING=true
            shift 1
            ;;
        --logging)
            LOGGING=true
            shift 1
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

sudo ssh-keygen -A
sudo /usr/sbin/sshd

if [ "$LOGGING" = true ] ; then
    sudo /sbin/syslogd
fi

if [ "$DEBUG" = true ] ; then
    bash
else
    # Ensure required arguments are set
    if [ -z "$INPUT_BANDWIDTH" ] || [ -z "$OUTPUT_BANDWIDTH" ] || [ -z "$STORE_SIZE" ]; then
        echo "Usage: $0 --input-bandwidth <value> --output-bandwidth <value> --store-size <value>"
        exit 1
    fi
    sudo chown -R hyphanet:hyphanet .

    echo "Input: ${INPUT_BANDWIDTH}"
    echo "Output: ${OUTPUT_BANDWIDTH}"
    echo "Store: ${STORE_SIZE}"

    # IO bandwidth and datastore size need customizing
    sed -i "s/{{ output_bandwidth }}/${OUTPUT_BANDWIDTH}/g" freenet.ini
    sed -i "s/{{ input_bandwidth }}/${INPUT_BANDWIDTH}/g" freenet.ini
    sed -i "s/{{ store_size }}/${STORE_SIZE}/g" freenet.ini

    # Persistent configuration
    ln -s data/freenet.ini freenet.ini

    # Persistent directories
    mkdir -p data/persistent-temp &&
        ln -s "${PWD}/data/persistent-temp" "persistent-temp"
    mkdir -p data/downloads &&
        ln -s "${PWD}/data/downloads" "downloads"
    mkdir -p data/datastore &&
        ln -s "${PWD}/data/datastore" "datastore"

    java -Xmx1500m -Xss512k -Dnetworkaddress.cache.ttl=0 -Dnetworkaddress.cache.negative.ttl=0 --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED  -cp bcprov-jdk15on-1.59.jar:freenet-ext.jar:freenet.jar:jna-4.5.2.jar:jna-platform-4.5.2.jar:pebble-3.1.5.jar:unbescape-1.1.6.RELEASE.jar:slf4j-api-1.7.25.jar freenet.node.NodeStarter
fi
