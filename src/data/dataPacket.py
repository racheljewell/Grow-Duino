import matplotlib.pyplot as plt

def plot_sensor_data(packets):
    arduino1_timestamps = []
    arduino1_light_sensor1_values = []
    arduino1_light_sensor2_values = []
    arduino1_humidity_values = []
    arduino1_temperature_values = []

    arduino2_timestamps = []
    arduino2_light_sensor1_values = []
    arduino2_light_sensor2_values = []
    arduino2_humidity_values = []
    arduino2_temperature_values = []

    for packet in packets:
        if packet.arduino_id == 'arduino1':
            arduino1_timestamps.append(packet.timestamp)
            arduino1_light_sensor1_values.append(packet.light_sensor1)
            arduino1_light_sensor2_values.append(packet.light_sensor2)
            arduino1_humidity_values.append(packet.humidity)
            arduino1_temperature_values.append(packet.temperature)
        elif packet.arduino_id == 'arduino2':
            arduino2_timestamps.append(packet.timestamp)
            arduino2_light_sensor1_values.append(packet.light_sensor1)
            arduino2_light_sensor2_values.append(packet.light_sensor2)
            arduino2_humidity_values.append(packet.humidity)
            arduino2_temperature_values.append(packet.temperature)

    # Plot Light Sensor Data
    plt.figure(figsize=(10, 6))
    plt.plot(arduino1_timestamps, arduino1_light_sensor1_values, label='Arduino 1 Light Sensor 1')
    plt.plot(arduino1_timestamps, arduino1_light_sensor2_values, label='Arduino 1 Light Sensor 2')
    plt.plot(arduino2_timestamps, arduino2_light_sensor1_values, label='Arduino 2 Light Sensor 1')
    plt.plot(arduino2_timestamps, arduino2_light_sensor2_values, label='Arduino 2 Light Sensor 2')
    plt.xlabel('Timestamp')
    plt.ylabel('Light Intensity')
    plt.title('Light Sensor Data over Time')
    plt.legend()
    plt.grid(True)
    plt.show()

    # Plot Humidity Data
    plt.figure(figsize=(10, 6))
    plt.plot(arduino1_timestamps, arduino1_humidity_values, label='Arduino 1 Humidity')
    plt.plot(arduino2_timestamps, arduino2_humidity_values, label='Arduino 2 Humidity')
    plt.xlabel('Timestamp')
    plt.ylabel('Humidity (%)')
    plt.title('Humidity Data over Time')
    plt.legend()
    plt.grid(True)
    plt.show()

    # Plot Temperature Data
    plt.figure(figsize=(10, 6))
    plt.plot(arduino1_timestamps, arduino1_temperature_values, label='Arduino 1 Temperature')
    plt.plot(arduino2_timestamps, arduino2_temperature_values, label='Arduino 2 Temperature')
    plt.xlabel('Timestamp')
    plt.ylabel('Temperature (°C)')
    plt.title('Temperature Data over Time')
    plt.legend()
    plt.grid(True)
    plt.show()


class DataPacket:
    def __init__(self, timestamp, arduino_id, light_sensor1, light_sensor2, humidity, temperature):
        self.timestamp = timestamp
        self.arduino_id = arduino_id
        self.light_sensor1 = light_sensor1
        self.light_sensor2 = light_sensor2
        self.humidity = humidity
        self.temperature = temperature

    @staticmethod
    def from_dict(source):
        packet = DataPacket(
            timestamp=source.get('timestamp'),
            arduino_id=source.get('arduino_id'),
            light_sensor1=source.get('light_sensor1'),
            light_sensor2=source.get('light_sensor2'),
            humidity=source.get('humidity'),
            temperature=source.get('temperature')
        )
        return packet

    def to_dict(self):
        return {
            'timestamp': self.timestamp,
            'arduino_id': self.arduino_id,
            'light_sensor1': self.light_sensor1,
            'light_sensor2': self.light_sensor2,
            'humidity': self.humidity,
            'temperature': self.temperature
        }

    def __repr__(self):
        return (
            f"DataPacket("
            f"timestamp={self.timestamp}, "
            f"arduino_id={self.arduino_id}, "
            f"light_sensor1={self.light_sensor1}, "
            f"light_sensor2={self.light_sensor2}, "
            f"humidity={self.humidity}, "
            f"temperature={self.temperature})"
        )

    def to_firestore_dict(self):
        return self.to_dict()
    
    def PrettyPrint(self):
        print("ArduinoID: ", self.arduino_id)
        print("Time: ", self.timestamp)
        print("Temperature: ", self.temperature)
        print("Humidity: ", self.humidity)
        print("Light1: ", self.light_sensor1)
        print("Light2: ", self.light_sensor2)
    
def ToPacket(source):
    source.to_dict()
    p = source.to_dict().get('packet', {})
    packet = DataPacket(
        timestamp=source.get('timestamp'),
        arduino_id=source.get('arduino_id'),
        light_sensor1=p.get('light_sensor1'),
        light_sensor2=p.get('light_sensor2'),
        humidity=p.get('humidity'),
        temperature=p.get('temperature')
    )
    return packet



