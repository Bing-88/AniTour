CREATE DATABASE IF NOT EXISTS anitour;
USE anitour;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    type ENUM('admin', 'user') NOT NULL DEFAULT 'user'
);

CREATE TABLE IF NOT EXISTS tours (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    image_path VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS stops (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tour_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    stop_order INT NOT NULL,
    FOREIGN KEY (tour_id) REFERENCES tours(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    tour_id INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (tour_id) REFERENCES tours(id) ON DELETE CASCADE
);

INSERT INTO users (username, password, email, type) VALUES
('admin', 'admin', 'admin@anitour.it', 'admin'),
('user', 'user', 'email@example.com', 'user');

INSERT INTO tours (name, description, price, start_date, end_date, image_path) VALUES
('Persona 5', '
                        Unisciti ai Ladri Fantasma e scopri il mondo di Persona 5!<br>
                        Maschere calate. Cuori da rubare. Ribellione tra ombre e citt&agrave; lucenti.<br>
                        Unisciti ai Ladri Fantasma, scopri la verit&agrave;.
                        Infiltrati nei Palazzi dell&rsquo;ordinario, risveglia il tuo io!<br>
                        Questo e molto altro, nel tour a tema Persona 5!
', 2039.49, '2025-05-01', '2025-05-15', '/AniTour/images/persona5.jpg');

INSERT INTO stops (tour_id, name, description, stop_order) VALUES
(1, 'Tokyo', 'Visita la capitale del Giappone, esplora i quartieri di Shibuya e Akihabara.', 1),
(1, 'Palazzo di Shido', 'Infiltrati nel Palazzo di Shido per rubare il suo cuore.', 2),
(1, 'Kichijoji', 'Scopri il quartiere di Kichijoji e incontra i tuoi amici.', 3);

INSERT INTO tours (name, description, price, start_date, end_date, image_path) VALUES
('Bloodborne', '
                Nebbia eterna. Campane lontane. Pietra, sangue e sogni spezzati.<br>
                Questo ed altro nel tour a tema Bloodborne.

', 770.49, '2025-09-01', '2025-09-10', '/AniTour/images/bloodborne.jpg');

INSERT INTO stops (tour_id, name, description, stop_order) VALUES
(2, 'Yharnam', 'Esplora la città di Yharnam e scopri i suoi segreti oscuri.', 1),
(2, 'Cattedrale di San Adella', 'Visita la cattedrale e affronta le sue creature mostruose.', 2),
(2, 'Bosco dei Sogni', 'Perditi nel Bosco dei Sogni e scopri la verità dietro il sangue.', 3);

INSERT INTO tours (name, description, price, start_date, end_date, image_path) VALUES
('Sekiro: Shadows Die Twice', '
                          Lama affilata. Ombre furtive. Onore, vendetta e redenzione.<br>
                          Tra castelli antichi e spiriti inquieti, cammina la via del lupo solitario.<br>
                          Questo e molto altro, nel tour a tema Sekiro!<br>
', 1200.00, '2025-10-01', '2025-10-15', '/AniTour/images/sekiro.jpg');

INSERT INTO stops (tour_id, name, description, stop_order) VALUES
(3, 'Castello di Ashina', 'Esplora il castello e affronta i suoi guardiani.', 1),
(3, 'Villaggio di Hirata', 'Scopri il villaggio e le sue tradizioni antiche.', 2),
(3, 'Tempio Senpou', 'Visita il tempio e incontra i suoi monaci.', 3);

INSERT INTO tours (name, description, price, start_date, end_date, image_path) VALUES
('K-ON!', '
                Musica, amicizia e momenti indimenticabili.<br>
                Unisciti al club di musica leggera e scopri il mondo di K-ON!<br>
                Questo e molto altro, nel tour a tema K-ON!<br>
', 500.00, '2025-06-01', '2025-06-10', '/AniTour/images/kon1.jpg');

INSERT INTO stops (tour_id, name, description, stop_order) VALUES
(4, 'Tokyo', 'Visita la capitale del Giappone e scopri i luoghi iconici di K-ON!', 1),
(4, 'Scuola Sakuragaoka', 'Esplora la scuola e incontra i membri del club di musica leggera.', 2),
(4, 'Caffè Ho-kago Tea Time', 'Rilassati al caffè e goditi un momento di musica e amicizia.', 3);\

INSERT INTO tours (name, description, price, start_date, end_date, image_path) VALUES
('Outer Wilds', '
                Esplora l\'universo, scopri antiche civilt&agrave; e risolvi il mistero del sistema solare.<br>
                Un viaggio tra stelle e pianeti, tra enigmi e scoperte.<br>
                Questo e molto altro, nel tour a tema Outer Wilds!<br>
', 40000099.99, '2025-07-01', '2025-07-15', '/AniTour/images/outerwilds.jpg');

INSERT INTO stops (tour_id, name, description, stop_order) VALUES
(5, 'Pianeta Hourglass', 'Esplora il pianeta Hourglass e scopri i suoi segreti.', 1),
(5, 'Carbonara Quantica', 'Risolvi gli enigmi del formaggioso pianeta Carbonara Quantica.', 2),
(5, 'Nebulosa di Dark Bramble', 'Perditi nella nebulosa e scopri la verità dietro il mistero.', 3);

INSERT INTO tours (name, description, price, start_date, end_date, image_path) VALUES
('Vinland Saga', '
                Unisciti a Thorfinn e scopri il mondo dei Vichinghi!<br>
                Tra battaglie, avventure e scoperte, vivi la storia di Vinland Saga.<br>
                Questo e molto altro, nel tour a tema Vinland Saga!<br>
', 999.99, '2025-08-01', '2025-08-15', '/AniTour/images/vinlandsaga1.jpg');

INSERT INTO stops (tour_id, name, description, stop_order) VALUES
(6, 'Islanda', 'Esplora l\'Islanda e scopri i luoghi iconici di Vinland Saga.', 1),
(6, 'Villaggio di Thorfinn', 'Visita il villaggio e incontra i personaggi della saga.', 2),
(6, 'Battaglia di Vinland', 'Partecipa alla battaglia e scopri il destino di Thorfinn.', 3);