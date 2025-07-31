set -e

#rm -rf build
cmake -B build -S . \
    -Werror=n \
    -DBUILD_TESTING=OFF \
    -DCMAKE_BUILD_TYPE="Release" \
    -DOTBR_BACKBONE_ROUTER=ON \
    -DOTBR_BORDER_ROUTING=ON \
    -DOTBR_COVERAGE=OFF \
    -DOTBR_MDNS=avahi \
    -DOTBR_NAT64=ON \
    -DOTBR_SRP_ADVERTISING_PROXY=ON \
    -DOTBR_TREL=ON \
    -DOTBR_VENDOR_NAME="eero" \
    -DOTBR_PRODUCT_NAME="thread" \
    -DOTBR_MESHCOP_SERVICE_INSTANCE_NAME="eero_thread" \
    -DOT_BACKBONE_ROUTER=ON \
    -DOT_READLINE=OFF \
    -DOT_FIREWALL=ON \
    -DOT_DUA=OFF \
    -DOT_FULL_LOGS=ON \
    -DOT_MLR=OFF \
    -DOT_LOG_LEVEL_DYNAMIC=ON \
    -DOT_POSIX_SETTINGS_PATH='"/tmp/cache/"' \
    -DOT_TX_BEACON_PAYLOAD=OFF \
    -DOT_NETDATA_PUBLISHER=ON \
    -DOTBR_DNSSD_DISCOVERY_PROXY=ON \
    -DOT_CONFIG=${PWD}/eero-configx.h \
    -DOT_POSIX_NAT64_CIDR="192.168.255.0/24" \
    -DOT_DIAGNOSTIC=1


cmake --build build -- -j12
sudo cmake --install build
cat << EOF | sudo tee /usr/local/etc/default/otbr-agent
OTBR_AGENT_OPTS="-d5 -I wpan0 -B wlp0s20f3 spinel+hdlc+uart:///dev/tty-SILABS-MG21?uart-baudrate=115200&uart-flow-control trel://wlp0s20f3"
OTBR_NO_AUTO_ATTACH=1
EOF
sudo systemctl daemon-reload