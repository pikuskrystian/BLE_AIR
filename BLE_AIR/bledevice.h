#ifndef BLEDEVICE_H
#define BLEDEVICE_H

#include <QObject>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothDeviceInfo>
#include <QLowEnergyController>
#include <QLowEnergyService>

#include "deviceinfo.h"

#define QPP_SERVICE_UUID "0000fee9-0000-1000-8000-00805f9b34fb"
#define QPP_RX_UUID "d44bc439-abfd-45a2-b575-925416129601"
#define QPP_TX_UUID "d44bc439-abfd-45a2-b575-925416129600"

typedef struct
{
    float temperature;
    float humidity;
    float pressure;
}sensorData_t;
class BLEDevice : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList deviceListModel READ deviceListModel WRITE setDeviceListModel RESET resetDeviceListModel NOTIFY deviceListModelChanged)

public:
    explicit BLEDevice(QObject *parent = nullptr);
    ~BLEDevice();

    QStringList deviceListModel();

private:
    DeviceInfo currentDevice;
    QBluetoothDeviceDiscoveryAgent *DiscoveryAgent;
    QList<QObject*> qlDevices;
    QLowEnergyController *controller;
    QLowEnergyDescriptor notificationDesc;
    QLowEnergyService *service, *serviceBatt;
    bool bFoundQppService;
    bool bFoundBattService;
    QStringList m_foundDevices;
    QStringList m_deviceListModel;

private slots:
    /* Slots for QBluetothDeviceDiscoveryAgent */
    void addDevice(const QBluetoothDeviceInfo &);
    void scanFinished();
    void deviceScanError(QBluetoothDeviceDiscoveryAgent::Error);

    /* Slots for QLowEnergyController */
    void serviceDiscovered(const QBluetoothUuid &);
    void serviceScanDone();
    void controllerError(QLowEnergyController::Error);
    void deviceConnected();
    void deviceDisconnected();

    /* Slotes for QLowEnergyService */
    void serviceStateChanged(QLowEnergyService::ServiceState);
    void serviceBattStateChanged(QLowEnergyService::ServiceState);
    void updateData(const QLowEnergyCharacteristic &, const QByteArray &);
    void confirmedDescriptorWrite(const QLowEnergyDescriptor &, const QByteArray &);

public slots:
    /* Slots for user */
    void startScan();
    void startConnect(int);
    void writeData(QByteArray);
    void setDeviceListModel(QStringList);
    void resetDeviceListModel();
    quint8 getBatteryLevel();

signals:
    /* Signals for user */
    void newData(QList<QVariant>);
    void scanningFinished();
    void connectionStart();
    void deviceListModelChanged(QStringList);
    void batteryLevel (quint8);
};

#endif // BLEDEVICE_H
