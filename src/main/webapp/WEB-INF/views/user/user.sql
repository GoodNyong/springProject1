show tables;

desc users;

CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT NOW(),
    updated_at DATETIME DEFAULT NOW()
    login_fail_count INT DEFAULT 0;
);

ALTER TABLE users ADD login_fail_count INT DEFAULT 0;

CREATE TABLE Roles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

DROP TABLE Roles;

DELETE FROM roles;

DESC roles;

select * from roles;
TRUNCATE TABLE roles;

INSERT INTO roles (role_name) VALUES
('ROLE_USER'),
('ROLE_EXPERT'),
('ROLE_ADVERTISER'),
('ROLE_ADMIN');

CREATE TABLE UserRoles (
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);

select * from users;