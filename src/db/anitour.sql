CREATE DATABASE IF NOT EXISTS anitour CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE anitour;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    type ENUM('admin', 'user') NOT NULL DEFAULT 'user'
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS tours (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    image_path VARCHAR(255),
    slug VARCHAR(255) NOT NULL UNIQUE,
    deleted BOOLEAN DEFAULT FALSE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS stops (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tour_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    stop_order INT NOT NULL,
    FOREIGN KEY (tour_id) REFERENCES tours(id) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    session_id VARCHAR(255), 
    tour_id INT,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(10, 2) NOT NULL, 
    tour_name VARCHAR(100), 
    tour_image_path VARCHAR(255), 
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('cart', 'completed') DEFAULT 'cart',
    shipping_name VARCHAR(100),
    shipping_address VARCHAR(255),
    shipping_city VARCHAR(100),
    shipping_country VARCHAR(100),
    shipping_postal_code VARCHAR(20),
    shipping_email VARCHAR(100),
    shipping_phone VARCHAR(20),
    payment_method VARCHAR(100) DEFAULT 'credit_card',
    payment_status ENUM('completed') DEFAULT 'completed',
    order_identifier VARCHAR(100) DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (tour_id) REFERENCES tours(id) ON DELETE SET NULL
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO users (username, password, email, type) VALUES
('admin', 'admin', 'admin@anitour.it', 'admin'),
('user', 'user', 'email@example.com', 'user');

INSERT INTO tours (name, description, price, start_date, end_date, image_path, slug) VALUES
('Persona 5', "Unisciti ai Ladri Fantasma e scopri il mondo di Persona 5! Maschere calate. Cuori da rubare. Ribellione tra ombre e umani corrotti. Unisciti ai Ladri Fantasma, indossa la tua maschera . Infiltrati nei Palazzi dell'ordinario, risveglia il tuo io! Questo e molto altro, nel tour a tema Persona 5!", 2039.49, '2025-05-01', '2025-05-15', '/AniTour/images/persona5.jpg', 'persona-5');

INSERT INTO stops (tour_id, name, description, stop_order) VALUES
(1, 'Tokyo', 'Visita la capitale del Giappone, esplora i quartieri di Shibuya e Akihabara.', 1),
(1, 'Palazzo di Shido', 'Infiltrati nel Palazzo di Shido per rubare il suo cuore.', 2),
(1, 'Kichijoji', 'Scopri il quartiere di Kichijoji e incontra i tuoi amici.', 3);

INSERT INTO tours (name, description, price, start_date, end_date, image_path, slug) VALUES
('Bloodborne', 'Nebbia eterna. Campane lontane. Pietra, sangue e sogni spezzati. Questo ed altro nel tour a tema Bloodborne.', 770.49, '2025-09-01', '2025-09-10', '/AniTour/images/bloodborne.jpg', 'bloodborne');

INSERT INTO stops (tour_id, name, description, stop_order) VALUES
(2, 'Yharnam', 'Esplora la cittadina di Yharnam e scopri i suoi segreti oscuri.', 1),
(2, 'Cattedrale di San Adella', 'Visita la cattedrale e affronta le sue creature mostruose.', 2),
(2, 'Bosco dei Sogni', 'Perditi nel Bosco dei Sogni e risolvi il mistero dietro il sangue.', 3);

INSERT INTO tours (name, description, price, start_date, end_date, image_path, slug) VALUES
('Sekiro: Shadows Die Twice', 'Lama affilata. Ombre furtive. Onore, vendetta e redenzione. Tra castelli antichi e spiriti inquieti, cammina la via del lupo solitario. Questo e molto altro, nel tour a tema Sekiro!', 1200.00, '2025-10-01', '2025-10-15', '/AniTour/images/sekiro.jpg', 'sekiro');

INSERT INTO stops (tour_id, name, description, stop_order) VALUES
(3, 'Castello di Ashina', 'Esplora il castello e affronta i suoi guardiani.', 1),
(3, 'Villaggio di Hirata', 'Scopri il villaggio e le sue tradizioni antiche.', 2),
(3, 'Tempio Senpou', 'Visita il tempio e incontra i suoi monaci.', 3);

INSERT INTO tours (name, description, price, start_date, end_date, image_path, slug) VALUES
('K-ON!', 'Musica, amicizia e momenti indimenticabili. Questo e molto altro, nel tour a tema K-ON!', 500.00, '2025-06-01', '2025-06-10', '/AniTour/images/kon1.jpg', 'k-on');

INSERT INTO stops (tour_id, name, description, stop_order) VALUES
(4, 'Tokyo', 'Visita la capitale del Giappone e scopri i luoghi iconici di K-ON!', 1),
(4, 'Scuola Sakuragaoka', 'Esplora la scuola e incontra i membri del club di musica leggera.', 2),
(4, 'Bar Ho-kago Tea Time', 'Rilassati e goditi un momento di musica e amicizia.', 3);

INSERT INTO tours (name, description, price, start_date, end_date, image_path, slug) VALUES
('Outer Wilds', "Esplora l'universo, scopri antiche popolazioni e risolvi il mistero del sistema solare. Questo e molto altro, nel tour a tema Outer Wilds!", 40000099.99, '2025-07-01', '2025-07-15', '/AniTour/images/outerwilds.jpg', 'outer-wilds');

INSERT INTO stops (tour_id, name, description, stop_order) VALUES
(5, 'Pianeta Hourglass', 'Esplora il pianeta Hourglass e scopri i suoi segreti.', 1),
(5, 'Carbonara Quantica', 'Risolvi gli enigmi del formaggioso pianeta Carbonara Quantica.', 2),
(5, 'Nebulosa di Dark Bramble', 'Perditi nella nebulosa e risolvi il mistero.', 3);

INSERT INTO tours (name, description, price, start_date, end_date, image_path, slug) VALUES
('Vinland Saga', 'Unisciti a Thorfinn e scopri il mondo dei Vichinghi! Questo e molto altro, nel tour a tema Vinland Saga!', 999.99, '2025-08-01', '2025-08-15', '/AniTour/images/vinlandsaga1.jpg', 'vinland-saga');

INSERT INTO stops (tour_id, name, description, stop_order) VALUES
(6, 'Islanda', "Esplora l'Islanda e scopri i luoghi iconici di Vinland Saga.", 1),
(6, 'Villaggio di Thorfinn', 'Visita il villaggio e incontra i personaggi della saga.', 2),
(6, 'Battaglia di Vinland', 'Partecipa alla battaglia e scopri il destino di Thorfinn.', 3);

INSERT INTO bookings (user_id, tour_id, quantity, price, tour_name, tour_image_path, booking_date, status, shipping_name, shipping_address, shipping_city, shipping_country, shipping_postal_code, shipping_email, shipping_phone, payment_method, payment_status, order_identifier) VALUES
(1, 1, 2, 2039.49, 'Persona 5', '/AniTour/images/persona5.jpg', '2024-11-15 14:30:00', 'completed', 'Admin AniTour', 'Via Roma 123', 'Milano', 'Italia', '20121', 'admin@anitour.it', '+39 02 1234567', 'credit_card', 'completed', 'ORD-2024-001');