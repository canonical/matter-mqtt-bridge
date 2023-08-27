# matter-mqtt-bridge

The files under "app" directory get copied into CHIP project's examples/bridge-app/linux to inject MQTT functionality into the upstream example. The reason for this approach is to maintain the simplicity of this example and rely on the existing upstream build configurations.

## Build
```bash
snapcraft -v
```
This will download >500MB and requires around 8GB of disk space. 

To build for other architectures, customize the `architectures` field inside the snapcraft.yaml and use snapcraft's [Remote build](https://snapcraft.io/docs/remote-build).
 
## Install

```bash
sudo snap install --dangerous *.snap
```

## Configure

### Setting MQTT Server Address

```bash
sudo snap set matter-mqtt-bridge server-address="tcp://localhost:1883"
```

### Setting MQTT Topic Prefix

```bash
sudo snap set matter-mqtt-bridge topic-prefix="test-topic-prefix"
```
This step is optional; the default topic prefix is "matter-bridge".

To see the list of all flags and SDK default, run the `help` app:
```bash
$ matter-mqtt-bridge.help 
...
Usage: /snap/matter-mqtt-bridge/x1/bin/chip-bridge-app [options

GENERAL OPTIONS

  --ble-device <number>
       The device number for CHIPoBLE, without 'hci' prefix, can be found by hciconfig.

  --wifi
       Enable WiFi management via wpa_supplicant.

  --thread
       Enable Thread management via ot-agent.
...
```

## Grant access

The snap uses [interfaces](https://snapcraft.io/docs/interface-management) to allow access to external resources. Depending on the use case, you need to "connect" certain interfaces to grant the necessary access.

### DNS-SD

The [avahi-control](https://snapcraft.io/docs/avahi-control-interface) is necessary to allow discovery of the application via DNS-SD:

```bash
sudo snap connect matter-mqtt-bridge:avahi-control
```

> **Note**  
> To make DNS-SD discovery work, the host also needs to have a running avahi-daemon which can be installed with `sudo apt install avahi-daemon` or `sudo snap install avahi`.

### BLE

Connect the [`bluez`](https://snapcraft.io/docs/bluez-interface) interface for device discovery over Bluetooth Low Energy (BLE):
```bash
sudo snap connect matter-mqtt-bridge:bluez
```

## Run
```bash
sudo snap start matter-mqtt-bridge
```
Add `--enable` to make the service automatically start at boot. 

Query and follow the logs:
```
sudo snap logs -n 100 -f matter-mqtt-bridge
```

## Control with Chip Tool

For the following examples, we use the [Chip Tool snap](https://snapcraft.io/chip-tool) to commission and control the bridge app.

### Commissioning

```bash
sudo snap connect chip-tool:avahi-observe
sudo chip-tool pairing onnetwork 110 20202021
```

where:

-   `110` is the assigned node id
-   `20202021` is the default passcode (pin code) for the lighting app

### Command

Switching on/off:

```bash
sudo chip-tool onoff toggle 110 1 # toggle is stateless and recommended
sudo chip-tool onoff on 110 1
sudo chip-tool onoff off 110 1
```

where:

-   `onoff` is the matter cluster name
-   `on`/`off`/`toggle` is the command name
-   `110` is the node id of the bridge assigned during the commissioning
-   `1` is the endpoint of the configured device

## Subscribe to MQTT messages

```bash
$ sudo snap install mosquitto
$ sudo mosquitto_sub -h localhost -t "#" -v

test-topic-prefix/3/OnOff/OnOff {
        "attributeId" : 0,
        "clusterId" : 6,
        "command" : "on",
        "deviceName" : "Light 1",
        "endpointId" : 3,
        "location" : "Office",
        "parentEndpointId" : 1,
        "zone" : ""
}
```

