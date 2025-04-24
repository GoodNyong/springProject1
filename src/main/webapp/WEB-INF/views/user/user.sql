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

INSERT INTO roles (role_id, role_name) VALUES
(1, 'admin'),
(2, 'expert'),
(3, 'advertiser'),
(4, 'user');

CREATE TABLE user_roles (
  user_id INT NOT NULL,
  role_id INT NOT NULL,
  PRIMARY KEY (user_id, role_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

DESC user_roles;

select * from user_roles;

select * from users;