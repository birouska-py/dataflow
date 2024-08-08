CREATE SCHEMA dw;

CREATE TABLE dw.dim_client (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_name VARCHAR(100) NOT NULL,
    client_document_number VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    country_code CHAR(3) NOT NULL
);

CREATE TABLE dw.dim_equipment (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    model VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE
);

CREATE TABLE dw.dim_vehicle (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    license_plate VARCHAR(20) NOT NULL,
    manufacturer VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    manufacture_year INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    client_id UUID NOT NULL,
    equipment_id UUID NOT NULL,
    FOREIGN KEY (client_id) REFERENCES dw.dim_client(id),
    FOREIGN KEY (equipment_id) REFERENCES dw.dim_equipment(id)
);

CREATE TABLE dw.dim_firmware (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    firmware_version VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    equipment_id UUID NOT NULL,
    FOREIGN KEY (equipment_id) REFERENCES dw.dim_equipment(id)
);

CREATE TABLE dw.dim_event (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event VARCHAR(255) NOT NULL,
    severity_classification VARCHAR(50) NOT NULL
);

CREATE TABLE dw.dim_driver (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    identification_document VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    client_id UUID NOT NULL,
    FOREIGN KEY (client_id) REFERENCES dw.dim_client(id)
);

CREATE TABLE dw.fct_position (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    dtposition TIMESTAMP NOT NULL,
    dtarrived TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    long DOUBLE PRECISION NOT NULL,
    lat DOUBLE PRECISION NOT NULL,
    odometer DOUBLE PRECISION NOT NULL,
    consume DOUBLE PRECISION NOT NULL,
    speedy DOUBLE PRECISION NOT NULL,
    equipment_id UUID NOT NULL,
    carddriver UUID NOT NULL,
    event_id UUID NOT NULL,
    FOREIGN KEY (equipment_id) REFERENCES dw.dim_equipment(id),
    FOREIGN KEY (carddriver) REFERENCES dw.dim_driver(id),
    FOREIGN KEY (event_id) REFERENCES dw.dim_event(id)
);

-- Insert data into dim_client
INSERT INTO dw.dim_client (id, client_name, client_document_number, start_date, end_date, country_code) VALUES
('00000000-0000-0000-0000-000000000001', 'Scooby Transportes', '12345678901', '2020-01-01', NULL, 'USA'),
('00000000-0000-0000-0000-000000000002', 'Flintstones Logistics', '23456789012', '2021-01-01', NULL, 'USA'),
('00000000-0000-0000-0000-000000000003', 'Jetsons Delivery', '34567890123', '2022-01-01', NULL, 'USA'),
('00000000-0000-0000-0000-000000000004', 'Yogi Bear Transport', '45678901234', '2023-01-01', NULL, 'USA'),
('00000000-0000-0000-0000-000000000005', 'Wacky Races Delivery', '56789012345', '2023-02-01', NULL, 'USA'),
('00000000-0000-0000-0000-000000000006', 'Top Cat Logistics', '67890123456', '2023-03-01', NULL, 'USA'),
('00000000-0000-0000-0000-000000000007', 'Magilla Gorilla Transport', '78901234567', '2023-04-01', NULL, 'USA'),
('00000000-0000-0000-0000-000000000008', 'Huckleberry Hound Delivery', '89012345678', '2023-05-01', NULL, 'USA'),
('00000000-0000-0000-0000-000000000009', 'Jabberjaw Logistics', '90123456789', '2023-06-01', NULL, 'USA'),
('00000000-0000-0000-0000-000000000010', 'Captain Caveman Transport', '01234567890', '2023-07-01', NULL, 'USA');

-- Insert data into dim_equipment
INSERT INTO dw.dim_equipment (id, model, start_date, end_date) VALUES
('10000000-0000-0000-0000-000000000001', 'Model A', '2020-01-01', NULL),
('10000000-0000-0000-0000-000000000002', 'Model B', '2021-01-01', NULL),
('10000000-0000-0000-0000-000000000003', 'Model C', '2022-01-01', NULL),
('10000000-0000-0000-0000-000000000004', 'Model D', '2023-01-01', NULL),
('10000000-0000-0000-0000-000000000005', 'Model E', '2023-02-01', NULL),
('10000000-0000-0000-0000-000000000006', 'Model F', '2023-03-01', NULL),
('10000000-0000-0000-0000-000000000007', 'Model G', '2023-04-01', NULL),
('10000000-0000-0000-0000-000000000008', 'Model H', '2023-05-01', NULL),
('10000000-0000-0000-0000-000000000009', 'Model I', '2023-06-01', NULL),
('10000000-0000-0000-0000-000000000010', 'Model J', '2023-07-01', NULL);

-- Insert data into dim_vehicle
INSERT INTO dw.dim_vehicle (id, license_plate, manufacturer, model, year, manufacture_year, start_date, end_date, client_id, equipment_id) VALUES
('20000000-0000-0000-0000-000000000001', 'ABC1234', 'Toyota', 'Corolla', 2020, 2019, '2020-01-01', NULL, '00000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001'),
('20000000-0000-0000-0000-000000000002', 'DEF5678', 'Honda', 'Civic', 2021, 2020, '2021-01-01', NULL, '00000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000002'),
('20000000-0000-0000-0000-000000000003', 'GHI9012', 'Ford', 'Focus', 2022, 2021, '2022-01-01', NULL, '00000000-0000-0000-0000-000000000003', '10000000-0000-0000-0000-000000000003'),
('20000000-0000-0000-0000-000000000004', 'JKL3456', 'Chevrolet', 'Cruze', 2023, 2022, '2023-01-01', NULL, '00000000-0000-0000-0000-000000000004', '10000000-0000-0000-0000-000000000004'),
('20000000-0000-0000-0000-000000000005', 'MNO4567', 'Nissan', 'Sentra', 2023, 2022, '2023-02-01', NULL, '00000000-0000-0000-0000-000000000005', '10000000-0000-0000-0000-000000000005'),
('20000000-0000-0000-0000-000000000006', 'PQR5678', 'Volkswagen', 'Jetta', 2023, 2022, '2023-03-01', NULL, '00000000-0000-0000-0000-000000000006', '10000000-0000-0000-0000-000000000006'),
('20000000-0000-0000-0000-000000000007', 'STU6789', 'Hyundai', 'Elantra', 2023, 2022, '2023-04-01', NULL, '00000000-0000-0000-0000-000000000007', '10000000-0000-0000-0000-000000000007'),
('20000000-0000-0000-0000-000000000008', 'VWX7890', 'Kia', 'Forte', 2023, 2022, '2023-05-01', NULL, '00000000-0000-0000-0000-000000000008', '10000000-0000-0000-0000-000000000008'),
('20000000-0000-0000-0000-000000000009', 'YZA8901', 'Mazda', '3', 2023, 2022, '2023-06-01', NULL, '00000000-0000-0000-0000-000000000009', '10000000-0000-0000-0000-000000000009'),
('20000000-0000-0000-0000-000000000010', 'BCD9012', 'Subaru', 'Impreza', 2023, 2022, '2023-07-01', NULL, '00000000-0000-0000-0000-000000000010', '10000000-0000-0000-0000-000000000010');

-- Insert data into dim_firmware
INSERT INTO dw.dim_firmware (id, firmware_version, start_date, end_date, equipment_id) VALUES
('30000000-0000-0000-0000-000000000001', 'v1.0', '2020-01-01', NULL, '10000000-0000-0000-0000-000000000001'),
('30000000-0000-0000-0000-000000000002', 'v1.1', '2021-01-01', NULL, '10000000-0000-0000-0000-000000000002'),
('30000000-0000-0000-0000-000000000003', 'v1.2', '2022-01-01', NULL, '10000000-0000-0000-0000-000000000003'),
('30000000-0000-0000-0000-000000000004', 'v1.3', '2023-01-01', NULL, '10000000-0000-0000-0000-000000000004'),
('30000000-0000-0000-0000-000000000005', 'v1.4', '2023-02-01', NULL, '10000000-0000-0000-0000-000000000005'),
('30000000-0000-0000-0000-000000000006', 'v1.5', '2023-03-01', NULL, '10000000-0000-0000-0000-000000000006'),
('30000000-0000-0000-0000-000000000007', 'v1.6', '2023-04-01', NULL, '10000000-0000-0000-0000-000000000007'),
('30000000-0000-0000-0000-000000000008', 'v1.7', '2023-05-01', NULL, '10000000-0000-0000-0000-000000000008'),
('30000000-0000-0000-0000-000000000009', 'v1.8', '2023-06-01', NULL, '10000000-0000-0000-0000-000000000009'),
('30000000-0000-0000-0000-000000000010', 'v1.9', '2023-07-01', NULL, '10000000-0000-0000-0000-000000000010');

-- Insert data into dim_event
INSERT INTO dw.dim_event (id, event, severity_classification) VALUES
('40000000-0000-0000-0000-000000000001', 'Harsh Acceleration', 'Medium'),
('40000000-0000-0000-0000-000000000002', 'Sharp Turn', 'Medium'),
('40000000-0000-0000-0000-000000000003', 'Sudden Stop', 'High'),
('40000000-0000-0000-0000-000000000004', 'Rapid Acceleration', 'High'),
('40000000-0000-0000-0000-000000000005', 'Rough Road', 'Low'),
('40000000-0000-0000-0000-000000000006', 'Maintenance Required', 'Low'),
('40000000-0000-0000-0000-000000000007', 'Battery Low', 'Medium'),
('40000000-0000-0000-0000-000000000008', 'Ignition On', 'Low'),
('40000000-0000-0000-0000-000000000009', 'Ignition Off', 'Low'),
('40000000-0000-0000-0000-000000000010', 'Speeding', 'High');

-- Insert data into dim_driver
INSERT INTO dw.dim_driver (id, name, birth_date, identification_document, start_date, end_date, client_id) VALUES
('50000000-0000-0000-0000-000000000001', 'Michael Schumacher', '1969-01-03', 'MS123456', '2023-01-01', NULL, '00000000-0000-0000-0000-000000000001'),
('50000000-0000-0000-0000-000000000002', 'Lewis Hamilton', '1985-01-07', 'LH123456', '2023-02-01', NULL, '00000000-0000-0000-0000-000000000002'),
('50000000-0000-0000-0000-000000000003', 'Juan Manuel Fangio', '1911-06-24', 'JMF123456', '2023-03-01', NULL, '00000000-0000-0000-0000-000000000003'),
('50000000-0000-0000-0000-000000000004', 'Alain Prost', '1955-02-24', 'AP123456', '2023-04-01', NULL, '00000000-0000-0000-0000-000000000004'),
('50000000-0000-0000-0000-000000000005', 'Sebastian Vettel', '1987-07-03', 'SV123456', '2023-05-01', NULL, '00000000-0000-0000-0000-000000000005'),
('50000000-0000-0000-0000-000000000006', 'Ayrton Senna', '1960-03-21', 'AS123456', '2023-06-01', NULL, '00000000-0000-0000-0000-000000000006'),
('50000000-0000-0000-0000-000000000007', 'Jackie Stewart', '1939-06-11', 'JS123456', '2023-07-01', NULL, '00000000-0000-0000-0000-000000000007'),
('50000000-0000-0000-0000-000000000008', 'Niki Lauda', '1949-02-22', 'NL123456', '2023-08-01', NULL, '00000000-0000-0000-0000-000000000008'),
('50000000-0000-0000-0000-000000000009', 'Nelson Piquet', '1952-08-17', 'NP123456', '2023-09-01', NULL, '00000000-0000-0000-0000-000000000009'),
('50000000-0000-0000-0000-000000000010', 'Fernando Alonso', '1981-07-29', 'FA123456', '2023-10-01', NULL, '00000000-0000-0000-0000-000000000010');

-- Insert data into fct_position
INSERT INTO dw.fct_position (id, dtposition, dtarrived, long, lat, odometer, consume, speedy, equipment_id, carddriver, event_id) VALUES
('60000000-0000-0000-0000-000000000001', '2023-01-01 08:00:00', '2023-01-01 08:01:00', -122.4194, 37.7749, 12345.6, 8.9, 65.0, '10000000-0000-0000-0000-000000000001', '50000000-0000-0000-0000-000000000001', '40000000-0000-0000-0000-000000000001'),
('60000000-0000-0000-0000-000000000002', '2023-01-02 09:00:00', '2023-01-02 09:01:00', -122.4194, 37.7749, 12355.6, 9.1, 60.0, '10000000-0000-0000-0000-000000000002', '50000000-0000-0000-0000-000000000002', '40000000-0000-0000-0000-000000000002'),
('60000000-0000-0000-0000-000000000003', '2023-01-03 10:00:00', '2023-01-03 10:01:00', -122.4194, 37.7749, 12365.6, 9.3, 62.0, '10000000-0000-0000-0000-000000000003', '50000000-0000-0000-0000-000000000003', '40000000-0000-0000-0000-000000000003'),
('60000000-0000-0000-0000-000000000004', '2023-01-04 11:00:00', '2023-01-04 11:01:00', -122.4194, 37.7749, 12375.6, 9.5, 61.0, '10000000-0000-0000-0000-000000000004', '50000000-0000-0000-0000-000000000004', '40000000-0000-0000-0000-000000000004'),
('60000000-0000-0000-0000-000000000005', '2023-01-05 12:00:00', '2023-01-05 12:01:00', -122.4194, 37.7749, 12385.6, 9.7, 63.0, '10000000-0000-0000-0000-000000000005', '50000000-0000-0000-0000-000000000005', '40000000-0000-0000-0000-000000000005'),
('60000000-0000-0000-0000-000000000006', '2023-01-06 13:00:00', '2023-01-06 13:01:00', -122.4194, 37.7749, 12395.6, 9.9, 64.0, '10000000-0000-0000-0000-000000000006', '50000000-0000-0000-0000-000000000006', '40000000-0000-0000-0000-000000000006'),
('60000000-0000-0000-0000-000000000007', '2023-01-07 14:00:00', '2023-01-07 14:01:00', -122.4194, 37.7749, 12405.6, 10.1, 66.0, '10000000-0000-0000-0000-000000000007', '50000000-0000-0000-0000-000000000007', '40000000-0000-0000-0000-000000000007'),
('60000000-0000-0000-0000-000000000008', '2023-01-08 15:00:00', '2023-01-08 15:01:00', -122.4194, 37.7749, 12415.6, 10.3, 67.0, '10000000-0000-0000-0000-000000000008', '50000000-0000-0000-0000-000000000008', '40000000-0000-0000-0000-000000000008'),
('60000000-0000-0000-0000-000000000009', '2023-01-09 16:00:00', '2023-01-09 16:01:00', -122.4194, 37.7749, 12425.6, 10.5, 68.0, '10000000-0000-0000-0000-000000000009', '50000000-0000-0000-0000-000000000009', '40000000-0000-0000-0000-000000000009'),
('60000000-0000-0000-0000-000000000010', '2023-01-10 17:00:00', '2023-01-10 17:01:00', -122.4194, 37.7749, 12435.6, 10.7, 69.0, '10000000-0000-0000-0000-000000000010', '50000000-0000-0000-0000-000000000010', '40000000-0000-0000-0000-000000000010');