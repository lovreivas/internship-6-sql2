CREATE TABLE team (
id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(100),
    city VARCHAR(100),
    contact_email VARCHAR(100),
    representative VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE referee (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tournament (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    location VARCHAR(100),
    winner_team_id INT REFERENCES team(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE player (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    position VARCHAR(30),
    team_id INT REFERENCES team(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE match_type (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE participation (
    id SERIAL PRIMARY KEY,
    tournament_id INT REFERENCES tournament(id) ON DELETE CASCADE,
    team_id INT REFERENCES team(id) ON DELETE CASCADE,
    points INT DEFAULT 0,
    standing INT, 
    stage_reached VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE game (
    id SERIAL PRIMARY KEY,
    tournament_id INT REFERENCES tournament(id) ON DELETE CASCADE,
    home_team_id INT REFERENCES team(id),
    away_team_id INT REFERENCES team(id),
    match_type_id INT REFERENCES match_type(id),
    referee_id INT REFERENCES referee(id),
    match_date TIMESTAMP NOT NULL,
    home_score INT DEFAULT 0,
    away_score INT DEFAULT 0,
    stadium VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE game_event (
    id SERIAL PRIMARY KEY,
    game_id INT REFERENCES game(id) ON DELETE CASCADE,
    player_id INT REFERENCES player(id),
    event_type VARCHAR(20) NOT NULL,
    minute INT NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);