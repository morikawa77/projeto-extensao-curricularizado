-- =====================================================
-- SISTEMA DE BANCO DE DADOS FÓRMULA 1 - OpenF1 API
-- Criado para análise de dados de corridas F1
-- Projeto de Extensão Comunitária (Curricularização)
-- Disciplina: Administração de Banco de Dados
-- Profa. Me. Valéria Maria Volpe
-- Alunos: Reginaldo Morikawa - Tháira Letícia Ibraim Lulio
-- =====================================================

-------------------------------------------------------------------------
-- Esta estrutura fornece:

-- Controle automatizado de atualizações (triggers)

-- Análises pré-formatadas (views)

-- Cálculos especializados (functions)

-- Operações complexas encapsuladas (stored procedures)

-- Otimização de consultas (índices)

-- As soluções consideram:

-- Auditoria de dados históricos

-- Performance em grandes volumes de dados

-- Integridade referencial

-- Usabilidade para análise de dados

-- Escalabilidade para múltiplas temporadas
-------------------------------------------------------------------------
-- Criar e usar novo banco de dados
CREATE DATABASE F1_OpenAPI
GO

USE F1_OpenAPI
GO

-- =====================================================
-- CRIAÇÃO DAS TABELAS PRINCIPAIS
-- =====================================================

-- Tabela de Países
CREATE TABLE Countries (
    country_key INT PRIMARY KEY,
    country_code VARCHAR(3) NOT NULL,
    country_name VARCHAR(100) NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE()
)
GO

-- Tabela de Circuitos
CREATE TABLE Circuits (
    circuit_key INT PRIMARY KEY,
    circuit_short_name VARCHAR(50) NOT NULL,
    location VARCHAR(100) NOT NULL,
    country_key INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (country_key) REFERENCES Countries(country_key)
)
GO

-- Tabela de Meetings (Grand Prix)
CREATE TABLE Meetings (
    meeting_key INT PRIMARY KEY,
    meeting_name VARCHAR(100) NOT NULL,
    meeting_official_name VARCHAR(200),
    circuit_key INT NOT NULL,
    date_start DATETIME2 NOT NULL,
    year INT NOT NULL,
    gmt_offset VARCHAR(10),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (circuit_key) REFERENCES Circuits(circuit_key)
)
GO

-- Tabela de Sessões
CREATE TABLE Sessions (
    session_key INT PRIMARY KEY,
    meeting_key INT NOT NULL,
    session_name VARCHAR(50) NOT NULL,
    session_type VARCHAR(50) NOT NULL,
    date_start DATETIME2 NOT NULL,
    date_end DATETIME2,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (meeting_key) REFERENCES Meetings(meeting_key)
)
GO

-- Tabela de Pilotos
CREATE TABLE Drivers (
    driver_id INT IDENTITY(1,1) PRIMARY KEY,
    driver_number INT NOT NULL,
    session_key INT NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    full_name VARCHAR(100),
    name_acronym VARCHAR(3),
    broadcast_name VARCHAR(50),
    team_name VARCHAR(50),
    team_colour VARCHAR(7),
    country_code VARCHAR(3),
    headshot_url VARCHAR(500),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (session_key) REFERENCES Sessions(session_key)
)
GO 

-- Tabela de Voltas
CREATE TABLE Laps (
    lap_id INT IDENTITY(1,1) PRIMARY KEY,
    session_key INT NOT NULL,
    driver_number INT NOT NULL,
    lap_number INT NOT NULL,
    date_start DATETIME2,
    lap_duration DECIMAL(8,3),
    duration_sector_1 DECIMAL(8,3),
    duration_sector_2 DECIMAL(8,3),
    duration_sector_3 DECIMAL(8,3),
    i1_speed INT,
    i2_speed INT,
    st_speed INT,
    is_pit_out_lap BIT DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (session_key) REFERENCES Sessions(session_key)
)
GO 

-- Tabela de Dados do Carro (Telemetria)
CREATE TABLE CarData (
    car_data_id INT IDENTITY(1,1) PRIMARY KEY,
    session_key INT NOT NULL,
    driver_number INT NOT NULL,
    date DATETIME2 NOT NULL,
    speed INT,
    throttle INT,
    brake INT,
    drs INT,
    n_gear INT,
    rpm INT,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (session_key) REFERENCES Sessions(session_key)
)
GO 

-- Tabela de Posições
CREATE TABLE Positions (
    position_id INT IDENTITY(1,1) PRIMARY KEY,
    session_key INT NOT NULL,
    driver_number INT NOT NULL,
    date DATETIME2 NOT NULL,
    position INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (session_key) REFERENCES Sessions(session_key)
)
GO 

-- Tabela de Pit Stops
CREATE TABLE PitStops (
    pit_id INT IDENTITY(1,1) PRIMARY KEY,
    session_key INT NOT NULL,
    driver_number INT NOT NULL,
    lap_number INT NOT NULL,
    date DATETIME2 NOT NULL,
    pit_duration DECIMAL(8,3),
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (session_key) REFERENCES Sessions(session_key)
)
GO 

-- Tabela de Clima
CREATE TABLE Weather (
    weather_id INT IDENTITY(1,1) PRIMARY KEY,
    session_key INT NOT NULL,
    date DATETIME2 NOT NULL,
    air_temperature DECIMAL(5,2),
    track_temperature DECIMAL(5,2),
    humidity INT,
    pressure DECIMAL(7,2),
    wind_speed DECIMAL(5,2),
    wind_direction INT,
    rainfall INT,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (session_key) REFERENCES Sessions(session_key)
)
GO 

-- Tabela de Stints (Períodos de Condução)
CREATE TABLE Stints (
    stint_id INT IDENTITY(1,1) PRIMARY KEY,
    session_key INT NOT NULL,
    driver_number INT NOT NULL,
    stint_number INT NOT NULL,
    lap_start INT,
    lap_end INT,
    compound VARCHAR(20),
    tyre_age_at_start INT,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (session_key) REFERENCES Sessions(session_key)
)
GO 

-- =====================================================
-- INSERÇÃO DE DADOS DE EXEMPLO (MÍNIMO 10 CADA TABELA)
-- =====================================================

-- Inserir Países
INSERT INTO Countries (country_key, country_code, country_name) VALUES
(1, 'BRA', 'Brazil'),
(2, 'MON', 'Monaco'),
(3, 'GBR', 'United Kingdom'),
(4, 'ITA', 'Italy'),
(5, 'ESP', 'Spain'),
(6, 'BEL', 'Belgium'),
(7, 'NLD', 'Netherlands'),
(8, 'AUS', 'Australia'),
(9, 'JPN', 'Japan'),
(10, 'USA', 'United States'),
(11, 'CAN', 'Canada'),
(12, 'FRA', 'France')
GO 

-- Inserir Circuitos
INSERT INTO Circuits (circuit_key, circuit_short_name, location, country_key) VALUES
(1, 'Interlagos', 'São Paulo', 1),
(2, 'Monaco', 'Monte Carlo', 2),
(3, 'Silverstone', 'Silverstone', 3),
(4, 'Monza', 'Monza', 4),
(5, 'Barcelona', 'Barcelona', 5),
(6, 'Spa-Francorchamps', 'Spa', 6),
(7, 'Zandvoort', 'Zandvoort', 7),
(8, 'Melbourne', 'Melbourne', 8),
(9, 'Suzuka', 'Suzuka', 9),
(10, 'Austin', 'Austin', 10),
(11, 'Montreal', 'Montreal', 11),
(12, 'Paul Ricard', 'Le Castellet', 12)
GO

-- Inserir Meetings
INSERT INTO Meetings (meeting_key, meeting_name, meeting_official_name, circuit_key, date_start, year, gmt_offset) VALUES
(2401, 'São Paulo Grand Prix', 'FORMULA 1 ROLEX SÃO PAULO GRAND PRIX 2024', 1, '2024-11-01 16:00:00', 2024, '-03:00'),
(2402, 'Monaco Grand Prix', 'FORMULA 1 GRAND PRIX DE MONACO 2024', 2, '2024-05-26 14:00:00', 2024, '+02:00'),
(2403, 'British Grand Prix', 'FORMULA 1 BRITISH GRAND PRIX 2024', 3, '2024-07-07 14:00:00', 2024, '+01:00'),
(2404, 'Italian Grand Prix', 'FORMULA 1 ITALIAN GRAND PRIX 2024', 4, '2024-09-01 14:00:00', 2024, '+02:00'),
(2405, 'Spanish Grand Prix', 'FORMULA 1 SPANISH GRAND PRIX 2024', 5, '2024-06-23 14:00:00', 2024, '+02:00'),
(2406, 'Belgian Grand Prix', 'FORMULA 1 BELGIAN GRAND PRIX 2024', 6, '2024-07-28 14:00:00', 2024, '+02:00'),
(2407, 'Dutch Grand Prix', 'FORMULA 1 DUTCH GRAND PRIX 2024', 7, '2024-08-25 14:00:00', 2024, '+02:00'),
(2408, 'Australian Grand Prix', 'FORMULA 1 AUSTRALIAN GRAND PRIX 2024', 8, '2024-03-24 14:00:00', 2024, '+11:00'),
(2409, 'Japanese Grand Prix', 'FORMULA 1 JAPANESE GRAND PRIX 2024', 9, '2024-04-07 14:00:00', 2024, '+09:00'),
(2410, 'United States Grand Prix', 'FORMULA 1 UNITED STATES GRAND PRIX 2024', 10, '2024-10-20 19:00:00', 2024, '-06:00'),
(2411, 'Canadian Grand Prix', 'FORMULA 1 CANADIAN GRAND PRIX 2024', 11, '2024-06-09 19:00:00', 2024, '-05:00'),
(2412, 'French Grand Prix', 'FORMULA 1 FRENCH GRAND PRIX 2024', 12, '2024-07-21 14:00:00', 2024, '+02:00')
GO 

-- Inserir Sessões
INSERT INTO Sessions (session_key, meeting_key, session_name, session_type, date_start, date_end) VALUES
(9001, 2401, 'Practice 1', 'Practice', '2024-11-01 16:30:00', '2024-11-01 17:30:00'),
(9002, 2401, 'Practice 2', 'Practice', '2024-11-01 20:00:00', '2024-11-01 21:00:00'),
(9003, 2401, 'Practice 3', 'Practice', '2024-11-02 15:30:00', '2024-11-02 16:30:00'),
(9004, 2401, 'Qualifying', 'Qualifying', '2024-11-02 19:00:00', '2024-11-02 20:00:00'),
(9005, 2401, 'Race', 'Race', '2024-11-03 17:00:00', '2024-11-03 19:00:00'),
(9006, 2402, 'Practice 1', 'Practice', '2024-05-26 12:30:00', '2024-05-26 13:30:00'),
(9007, 2402, 'Qualifying', 'Qualifying', '2024-05-26 16:00:00', '2024-05-26 17:00:00'),
(9008, 2402, 'Race', 'Race', '2024-05-26 15:00:00', '2024-05-26 17:00:00'),
(9009, 2403, 'Sprint', 'Race', '2024-07-07 15:30:00', '2024-07-07 16:00:00'),
(9010, 2403, 'Race', 'Race', '2024-07-07 15:00:00', '2024-07-07 17:00:00'),
(9011, 2404, 'Practice 1', 'Practice', '2024-09-01 12:30:00', '2024-09-01 13:30:00'),
(9012, 2404, 'Race', 'Race', '2024-09-01 14:00:00', '2024-09-01 16:00:00'),
(9013, 2402, 'Race', 'Race', '2024-05-26 15:00:00', '2024-05-26 17:00:00'),
(9014, 2403, 'Race', 'Race', '2024-07-07 15:00:00', '2024-07-07 17:00:00')
GO 

-- Inserir Pilotos
INSERT INTO Drivers (driver_number, session_key, first_name, last_name, full_name, name_acronym, broadcast_name, team_name, team_colour, country_code) VALUES
(1, 9001, 'Max', 'Verstappen', 'Max VERSTAPPEN', 'VER', 'M VERSTAPPEN', 'Red Bull Racing', '#3671C6', 'NED'),
(11, 9001, 'Sergio', 'Pérez', 'Sergio PÉREZ', 'PER', 'S PEREZ', 'Red Bull Racing', '#3671C6', 'MEX'),
(44, 9001, 'Lewis', 'Hamilton', 'Lewis HAMILTON', 'HAM', 'L HAMILTON', 'Mercedes', '#27F4D2', 'GBR'),
(63, 9001, 'George', 'Russell', 'George RUSSELL', 'RUS', 'G RUSSELL', 'Mercedes', '#27F4D2', 'GBR'),
(16, 9001, 'Charles', 'Leclerc', 'Charles LECLERC', 'LEC', 'C LECLERC', 'Ferrari', '#F91536', 'MON'),
(55, 9001, 'Carlos', 'Sainz', 'Carlos SAINZ', 'SAI', 'C SAINZ', 'Ferrari', '#F91536', 'ESP'),
(4, 9001, 'Lando', 'Norris', 'Lando NORRIS', 'NOR', 'L NORRIS', 'McLaren', '#FF8000', 'GBR'),
(81, 9001, 'Oscar', 'Piastri', 'Oscar PIASTRI', 'PIA', 'O PIASTRI', 'McLaren', '#FF8000', 'AUS'),
(14, 9001, 'Fernando', 'Alonso', 'Fernando ALONSO', 'ALO', 'F ALONSO', 'Aston Martin', '#229971', 'ESP'),
(18, 9001, 'Lance', 'Stroll', 'Lance STROLL', 'STR', 'L STROLL', 'Aston Martin', '#229971', 'CAN'),
(10, 9001, 'Pierre', 'Gasly', 'Pierre GASLY', 'GAS', 'P GASLY', 'Alpine', '#2293D1', 'FRA'),
(31, 9001, 'Esteban', 'Ocon', 'Esteban OCON', 'OCO', 'E OCON', 'Alpine', '#2293D1', 'FRA'),
(1, 9005, 'Max', 'Verstappen', 'Max VERSTAPPEN', 'VER', 'M VERSTAPPEN', 'Red Bull Racing', '#3671C6', 'NED'),
(44, 9005, 'Lewis', 'Hamilton', 'Lewis HAMILTON', 'HAM', 'L HAMILTON', 'Mercedes', '#27F4D2', 'GBR'),
(16, 9005, 'Charles', 'Leclerc', 'Charles LECLERC', 'LEC', 'C LECLERC', 'Ferrari', '#F91536', 'MON'),
(4, 9005, 'Lando', 'Norris', 'Lando NORRIS', 'NOR', 'L NORRIS', 'McLaren', '#FF8000', 'GBR'),
(11, 9005, 'Sergio', 'Pérez', 'Sergio PÉREZ', 'PER', 'S PEREZ', 'Red Bull Racing', '#3671C6', 'MEX'),
(55, 9005, 'Carlos', 'Sainz', 'Carlos SAINZ', 'SAI', 'C SAINZ', 'Ferrari', '#F91536', 'ESP'),
(63, 9005, 'George', 'Russell', 'George RUSSELL', 'RUS', 'G RUSSELL', 'Mercedes', '#27F4D2', 'GBR'),
(81, 9005, 'Oscar', 'Piastri', 'Oscar PIASTRI', 'PIA', 'O PIASTRI', 'McLaren', '#FF8000', 'AUS'),
(14, 9005, 'Fernando', 'Alonso', 'Fernando ALONSO', 'ALO', 'F ALONSO', 'Aston Martin', '#229971', 'ESP'),
(18, 9005, 'Lance', 'Stroll', 'Lance STROLL', 'STR', 'L STROLL', 'Aston Martin', '#229971', 'CAN'),
(10, 9005, 'Pierre', 'Gasly', 'Pierre GASLY', 'GAS', 'P GASLY', 'Alpine', '#2293D1', 'FRA'),
(31, 9005, 'Esteban', 'Ocon', 'Esteban OCON', 'OCO', 'E OCON', 'Alpine', '#2293D1', 'FRA'),
(1, 9013, 'Max', 'Verstappen', 'Max VERSTAPPEN', 'VER', 'M VERSTAPPEN', 'Red Bull Racing', '#3671C6', 'NED'),
(16, 9013, 'Charles', 'Leclerc', 'Charles LECLERC', 'LEC', 'C LECLERC', 'Ferrari', '#F91536', 'MON'),
(44, 9014, 'Lewis', 'Hamilton', 'Lewis HAMILTON', 'HAM', 'L HAMILTON', 'Mercedes', '#27F4D2', 'GBR'),
(4, 9014, 'Lando', 'Norris', 'Lando NORRIS', 'NOR', 'L NORRIS', 'McLaren', '#FF8000', 'GBR')
GO 

-- Inserir Voltas
INSERT INTO Laps (session_key, driver_number, lap_number, date_start, lap_duration, duration_sector_1, duration_sector_2, duration_sector_3, i1_speed, i2_speed, st_speed, is_pit_out_lap) VALUES
(9005, 1, 1, '2024-11-03 17:05:00', 72.345, 24.123, 26.890, 21.332, 315, 287, 298, 1),
(9005, 1, 2, '2024-11-03 17:06:12', 70.892, 23.456, 26.123, 21.313, 320, 289, 301, 0),
(9005, 1, 3, '2024-11-03 17:07:23', 70.567, 23.234, 25.989, 21.344, 318, 291, 299, 0),
(9005, 44, 1, '2024-11-03 17:05:02', 72.789, 24.345, 27.123, 21.321, 312, 284, 295, 1),
(9005, 44, 2, '2024-11-03 17:06:15', 71.234, 23.567, 26.345, 21.322, 317, 286, 297, 0),
(9005, 16, 1, '2024-11-03 17:05:01', 72.567, 24.234, 26.789, 21.544, 314, 286, 296, 1),
(9005, 16, 2, '2024-11-03 17:06:14', 70.789, 23.345, 26.012, 21.432, 319, 288, 300, 0),
(9005, 4, 1, '2024-11-03 17:05:03', 73.123, 24.456, 27.234, 21.433, 311, 283, 294, 1),
(9005, 4, 2, '2024-11-03 17:06:16', 71.456, 23.678, 26.456, 21.322, 316, 285, 296, 0),
(9005, 55, 1, '2024-11-03 17:05:04', 72.890, 24.345, 27.012, 21.533, 313, 285, 297, 1),
(9005, 55, 2, '2024-11-03 17:06:17', 71.123, 23.445, 26.234, 21.444, 318, 287, 299, 0),
(9005, 11, 1, '2024-11-03 17:05:05', 73.234, 24.567, 27.345, 21.322, 310, 282, 293, 1)
GO 

-- Inserir Dados do Carro
INSERT INTO CarData (session_key, driver_number, date, speed, throttle, brake, drs, n_gear, rpm) VALUES
(9005, 1, '2024-11-03 17:05:15', 315, 99, 0, 12, 8, 11500),
(9005, 1, '2024-11-03 17:05:16', 320, 95, 0, 10, 8, 11600),
(9005, 1, '2024-11-03 17:05:17', 285, 0, 100, 0, 6, 9800),
(9005, 44, '2024-11-03 17:05:15', 312, 98, 0, 12, 8, 11400),
(9005, 44, '2024-11-03 17:05:16', 318, 94, 0, 10, 8, 11550),
(9005, 16, '2024-11-03 17:05:15', 314, 97, 0, 12, 8, 11450),
(9005, 16, '2024-11-03 17:05:16', 290, 0, 95, 0, 6, 9900),
(9005, 4, '2024-11-03 17:05:15', 311, 96, 0, 12, 8, 11350),
(9005, 55, '2024-11-03 17:05:15', 313, 98, 0, 12, 8, 11420),
(9005, 11, '2024-11-03 17:05:15', 310, 95, 0, 12, 8, 11300),
(9005, 63, '2024-11-03 17:05:15', 316, 99, 0, 12, 8, 11480),
(9005, 81, '2024-11-03 17:05:15', 309, 94, 0, 12, 8, 11280)
GO 

-- Inserir Posições
INSERT INTO Positions (session_key, driver_number, date, position) VALUES
(9005, 1, '2024-11-03 17:05:00', 1),
(9005, 16, '2024-11-03 17:05:00', 2),
(9005, 4, '2024-11-03 17:05:00', 3),
(9005, 44, '2024-11-03 17:05:00', 4),
(9005, 55, '2024-11-03 17:05:00', 5),
(9005, 11, '2024-11-03 17:05:00', 6),
(9005, 63, '2024-11-03 17:05:00', 7),
(9005, 81, '2024-11-03 17:05:00', 8),
(9005, 14, '2024-11-03 17:05:00', 9),
(9005, 18, '2024-11-03 17:05:00', 10),
(9005, 10, '2024-11-03 17:05:00', 11),
(9005, 31, '2024-11-03 17:05:00', 12)
GO 

-- Inserir Pit Stops
INSERT INTO PitStops (session_key, driver_number, lap_number, date, pit_duration) VALUES
(9005, 1, 18, '2024-11-03 17:23:45', 23.456),
(9005, 44, 19, '2024-11-03 17:24:52', 24.123),
(9005, 16, 20, '2024-11-03 17:25:48', 22.789),
(9005, 4, 17, '2024-11-03 17:22:34', 25.234),
(9005, 55, 21, '2024-11-03 17:26:55', 23.890),
(9005, 11, 22, '2024-11-03 17:27:48', 24.567),
(9005, 63, 18, '2024-11-03 17:23:52', 23.123),
(9005, 81, 19, '2024-11-03 17:24:45', 24.890),
(9005, 14, 20, '2024-11-03 17:25:38', 22.456),
(9005, 18, 17, '2024-11-03 17:22:41', 25.678),
(9005, 10, 21, '2024-11-03 17:26:42', 24.234),
(9005, 31, 22, '2024-11-03 17:27:35', 23.567)
GO 

-- Inserir Clima
INSERT INTO Weather (session_key, date, air_temperature, track_temperature, humidity, pressure, wind_speed, wind_direction, rainfall) VALUES
(9005, '2024-11-03 17:00:00', 28.5, 42.3, 65, 1013.2, 3.2, 180, 0),
(9005, '2024-11-03 17:15:00', 29.1, 43.8, 63, 1013.0, 3.5, 185, 0),
(9005, '2024-11-03 17:30:00', 29.8, 45.2, 61, 1012.8, 3.8, 190, 0),
(9005, '2024-11-03 17:45:00', 30.2, 46.5, 59, 1012.6, 4.1, 195, 0),
(9005, '2024-11-03 18:00:00', 30.5, 47.8, 57, 1012.4, 4.3, 200, 0),
(9006, '2024-05-26 15:00:00', 22.3, 35.6, 72, 1015.8, 2.1, 120, 0),
(9006, '2024-05-26 15:15:00', 23.1, 36.8, 70, 1015.6, 2.3, 125, 0),
(9006, '2024-05-26 15:30:00', 23.8, 38.2, 68, 1015.4, 2.5, 130, 0),
(9006, '2024-05-26 15:45:00', 24.2, 39.5, 66, 1015.2, 2.7, 135, 0),
(9006, '2024-05-26 16:00:00', 24.8, 40.8, 64, 1015.0, 2.9, 140, 0),
(9007, '2024-05-26 16:00:00', 24.5, 40.2, 65, 1015.1, 2.8, 138, 0),
(9008, '2024-05-26 15:00:00', 25.2, 41.5, 63, 1014.8, 3.1, 142, 0)
GO 

-- Inserir Stints
INSERT INTO Stints (session_key, driver_number, stint_number, lap_start, lap_end, compound, tyre_age_at_start) VALUES
(9005, 1, 1, 1, 18, 'SOFT', 0),
(9005, 1, 2, 19, 35, 'MEDIUM', 2),
(9005, 1, 3, 36, 50, 'HARD', 1),
(9005, 44, 1, 1, 19, 'SOFT', 0),
(9005, 44, 2, 20, 36, 'MEDIUM', 3),
(9005, 44, 3, 37, 50, 'HARD', 0),
(9005, 16, 1, 1, 20, 'SOFT', 1),
(9005, 16, 2, 21, 37, 'MEDIUM', 0),
(9005, 16, 3, 38, 50, 'HARD', 2),
(9005, 4, 1, 1, 17, 'SOFT', 0),
(9005, 4, 2, 18, 34, 'MEDIUM', 1),
(9005, 4, 3, 35, 50, 'HARD', 0),
(9013, 1, 1, 1, 25, 'SOFT', 0),
(9014, 44, 1, 1, 22, 'MEDIUM', 1)
GO 

-- =====================================================
-- CRIAÇÃO DE ÍNDICES PARA OTIMIZAÇÃO
-- =====================================================

-- Índices nas chaves estrangeiras
CREATE INDEX IX_Circuits_CountryKey ON Circuits(country_key)
CREATE INDEX IX_Meetings_CircuitKey ON Meetings(circuit_key)
CREATE INDEX IX_Sessions_MeetingKey ON Sessions(meeting_key)
CREATE INDEX IX_Drivers_SessionKey ON Drivers(session_key)
CREATE INDEX IX_Laps_SessionKey ON Laps(session_key)
CREATE INDEX IX_CarData_SessionKey ON CarData(session_key)
CREATE INDEX IX_Positions_SessionKey ON Positions(session_key)
CREATE INDEX IX_PitStops_SessionKey ON PitStops(session_key)
CREATE INDEX IX_Weather_SessionKey ON Weather(session_key)
CREATE INDEX IX_Stints_SessionKey ON Stints(session_key)

-- Índices para consultas frequentes
CREATE INDEX IX_Laps_DriverNumber ON Laps(driver_number)
CREATE INDEX IX_CarData_DriverNumber ON CarData(driver_number)
CREATE INDEX IX_Positions_DriverNumber ON Positions(driver_number)
CREATE INDEX IX_Meetings_Year ON Meetings(year)
CREATE INDEX IX_Sessions_SessionType ON Sessions(session_type)
GO 

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

-- Procedure para obter estatísticas de um piloto
CREATE OR ALTER PROCEDURE sp_GetDriverStatistics
    @DriverNumber INT,
    @SessionKey INT = NULL
AS
BEGIN
    SET NOCOUNT ON
    
    SELECT 
        d.full_name,
        d.team_name,
        COUNT(l.lap_id) as total_laps,
        AVG(l.lap_duration) as avg_lap_time,
        MIN(l.lap_duration) as best_lap_time,
        MAX(l.lap_duration) as worst_lap_time,
        AVG(CAST(cd.speed AS FLOAT)) as avg_speed,
        MAX(cd.speed) as max_speed,
        COUNT(ps.pit_id) as total_pit_stops,
        AVG(ps.pit_duration) as avg_pit_duration
    FROM Drivers d
    LEFT JOIN Laps l ON d.driver_number = l.driver_number AND d.session_key = l.session_key
    LEFT JOIN CarData cd ON d.driver_number = cd.driver_number AND d.session_key = cd.session_key
    LEFT JOIN PitStops ps ON d.driver_number = ps.driver_number AND d.session_key = ps.session_key
    WHERE d.driver_number = @DriverNumber
        AND (@SessionKey IS NULL OR d.session_key = @SessionKey)
    GROUP BY d.full_name, d.team_name
END
GO

-- Procedure para registrar novos pit stops
CREATE OR ALTER PROCEDURE sp_InsertPitStop
    @session_key INT,
    @driver_number INT,
    @lap_number INT,
    @date DATETIME2,
    @pit_duration DECIMAL(8,3)
AS
BEGIN
    INSERT INTO PitStops (session_key, driver_number, lap_number, date, pit_duration)
    VALUES (@session_key, @driver_number, @lap_number, @date, @pit_duration)
END
GO

-- Procedure para atualizar informações de pilotos
CREATE OR ALTER PROCEDURE sp_UpdateDriverInfo
    @driver_id INT,
    @driver_number INT,
    @first_name VARCHAR(50) = NULL,
    @last_name VARCHAR(50) = NULL,
    @team_name VARCHAR(50) = NULL,
    @country_code VARCHAR(3) = NULL
AS
BEGIN
    UPDATE Drivers
    SET 
        driver_number = @driver_number,
        first_name = ISNULL(@first_name, first_name),
        last_name = ISNULL(@last_name, last_name),
        team_name = ISNULL(@team_name, team_name),
        country_code = ISNULL(@country_code, country_code),
        updated_at = GETDATE()
    WHERE driver_id = @driver_id
END
GO

-- Procedure para análise de desempenho por circuito
CREATE OR ALTER PROCEDURE sp_GetCircuitPerformance
    @circuit_key INT
AS
BEGIN
    SELECT 
        c.circuit_short_name,
        d.full_name,
        AVG(l.lap_duration) AS avg_lap_time,
        MIN(l.lap_duration) AS best_lap_time
    FROM Laps l
    JOIN Sessions s ON l.session_key = s.session_key
    JOIN Meetings m ON s.meeting_key = m.meeting_key
    JOIN Circuits c ON m.circuit_key = c.circuit_key
    JOIN Drivers d ON l.driver_number = d.driver_number AND l.session_key = d.session_key
    WHERE c.circuit_key = @circuit_key
        AND s.session_type = 'Race'
    GROUP BY c.circuit_short_name, d.full_name
    ORDER BY avg_lap_time
END
GO

-- =====================================================
-- VIEWS
-- =====================================================

-- View consolidada de informações de corrida
CREATE OR ALTER VIEW vw_RaceDetails
AS
SELECT
    m.meeting_official_name,
    s.session_name,
    s.date_start AS session_start,
    c.circuit_short_name,
    cnt.country_name,
    d.full_name AS driver_name,
    d.team_name,
    l.lap_number,
    l.lap_duration
FROM Laps l
JOIN Sessions s ON l.session_key = s.session_key
JOIN Meetings m ON s.meeting_key = m.meeting_key
JOIN Circuits c ON m.circuit_key = c.circuit_key
JOIN Countries cnt ON c.country_key = cnt.country_key
JOIN Drivers d ON l.driver_number = d.driver_number AND l.session_key = d.session_key
GO

-- View de dados meteorológicos por sessão
CREATE OR ALTER VIEW vw_SessionWeather
AS
SELECT
    s.session_key,
    m.meeting_name,
    s.session_name,
    w.date,
    w.air_temperature,
    w.track_temperature,
    w.humidity,
    w.rainfall
FROM Weather w
JOIN Sessions s ON w.session_key = s.session_key
JOIN Meetings m ON s.meeting_key = m.meeting_key
GO

-- View de estratégia de corrida (pneus e pit stops)
CREATE OR ALTER VIEW vw_RaceStrategy
AS
SELECT
    d.full_name,
    s.session_name,
    m.meeting_name,
    st.stint_number,
    st.lap_start,
    st.lap_end,
    st.compound,
    ps.pit_duration,
    ps.date AS pit_stop_time
FROM Stints st
JOIN Drivers d ON st.driver_number = d.driver_number AND st.session_key = d.session_key
JOIN Sessions s ON st.session_key = s.session_key
JOIN Meetings m ON s.meeting_key = m.meeting_key
LEFT JOIN PitStops ps ON st.session_key = ps.session_key 
    AND st.driver_number = ps.driver_number 
    AND ps.lap_number BETWEEN st.lap_start AND st.lap_end
GO

-- =====================================================
-- TRIGGERS
-- =====================================================

-- Trigger para atualizar automaticamente 'updated_at' em Drivers
CREATE OR ALTER TRIGGER trg_Drivers_Update
ON Drivers
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON
    
    UPDATE d
    SET updated_at = GETDATE()
    FROM Drivers d
    INNER JOIN inserted i ON d.driver_id = i.driver_id
END
GO

-- Tabela para histórico de voltas e trigger
CREATE TABLE LapHistory (
    history_id INT IDENTITY PRIMARY KEY,
    lap_id INT,
    old_lap_duration DECIMAL(8,3),
    new_lap_duration DECIMAL(8,3),
    change_date DATETIME2 DEFAULT GETDATE()
)
GO

CREATE OR ALTER TRIGGER trg_Laps_Update
ON Laps
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON
    
    INSERT INTO LapHistory (lap_id, old_lap_duration, new_lap_duration)
    SELECT 
        d.lap_id,
        d.lap_duration,
        i.lap_duration
    FROM deleted d
    INNER JOIN inserted i ON d.lap_id = i.lap_id
    WHERE d.lap_duration <> i.lap_duration
END
GO

-- =====================================================
-- FUNCTIONS
-- =====================================================

-- Função para calcular velocidade média por setor
CREATE OR ALTER FUNCTION fn_CalculateSectorSpeed (
    @distance_sector_1 FLOAT,
    @distance_sector_2 FLOAT,
    @distance_sector_3 FLOAT
)
RETURNS @sectorSpeeds TABLE (
    sector_1_speed FLOAT,
    sector_2_speed FLOAT,
    sector_3_speed FLOAT
)
AS
BEGIN
    INSERT INTO @sectorSpeeds
    SELECT
        AVG(@distance_sector_1 / NULLIF(l.duration_sector_1, 0)) * 3.6,
        AVG(@distance_sector_2 / NULLIF(l.duration_sector_2, 0)) * 3.6,
        AVG(@distance_sector_3 / NULLIF(l.duration_sector_3, 0)) * 3.6
    FROM Laps l
    
    RETURN
END
GO

-- Função para obter resultados finais de uma corrida
CREATE OR ALTER FUNCTION fn_GetRaceResults (@session_key INT)
RETURNS TABLE
AS
RETURN (
    SELECT
        ROW_NUMBER() OVER (ORDER BY MIN(l.lap_duration) ASC) AS position,
        d.driver_number,
        d.full_name,
        d.team_name,
        COUNT(DISTINCT l.lap_number) AS laps_completed,
        MIN(l.lap_duration) AS best_lap
    FROM Drivers d
    LEFT JOIN Laps l ON d.driver_number = l.driver_number AND d.session_key = l.session_key
    WHERE d.session_key = @session_key
    GROUP BY d.driver_number, d.full_name, d.team_name
)
GO

-- Função para calcular diferença de tempo entre pilotos
CREATE OR ALTER FUNCTION fn_GetTimeDifference (
    @session_key INT,
    @driver1 INT,
    @driver2 INT
)
RETURNS DECIMAL(8,3)
AS
BEGIN
    DECLARE @diff DECIMAL(8,3)
    
    SELECT @diff = AVG(l1.lap_duration - l2.lap_duration)
    FROM Laps l1
    JOIN Laps l2 ON l1.lap_number = l2.lap_number
    WHERE l1.session_key = @session_key
        AND l2.session_key = @session_key
        AND l1.driver_number = @driver1
        AND l2.driver_number = @driver2
    
    RETURN @diff
END
GO

-- =====================================================
-- ÍNDICES ADICIONAIS
-- =====================================================

CREATE INDEX IX_Laps_LapNumber ON Laps(lap_number)
CREATE INDEX IX_CarData_Date ON CarData(date)
CREATE INDEX IX_Positions_Date ON Positions(date)
CREATE INDEX IX_Stints_Compound ON Stints(compound)
GO

-- =====================================================
-- TESTES
-- =====================================================

-- Deve retornar resultados para a corrida de São Paulo
SELECT * FROM fn_GetRaceResults(9005)
GO

-- Deve mostrar estratégia do Verstappen
SELECT * FROM vw_RaceStrategy 
WHERE full_name = 'Max VERSTAPPEN'
GO 

-- Teste adicional para estratégia de Hamilton
SELECT * FROM vw_RaceStrategy 
WHERE full_name = 'Lewis HAMILTON'
GO 

-- Calcular diferença de tempo entre pilotos:
SELECT dbo.fn_GetTimeDifference(9005, 1, 44) AS Verstappen_vs_Hamilton
GO 

-- Atualizar informações do piloto:
EXEC sp_UpdateDriverInfo 
    @driver_id = 1,
    @driver_number = 33,
    @team_name = 'Red Bull Racing'
GO 