CREATE INDEX idx_game_tournament_id ON game(tournament_id);
CREATE INDEX idx_game_home_team_id ON game(home_team_id);
CREATE INDEX idx_game_away_team_id ON game(away_team_id);
CREATE INDEX idx_game_match_type_id ON game(match_type_id);
CREATE INDEX idx_game_referee_id ON game(referee_id);

CREATE INDEX idx_participation_tournament_id ON participation(tournament_id);
CREATE INDEX idx_participation_team_id ON participation(team_id);

CREATE INDEX idx_game_event_game_id ON game_event(game_id);
CREATE INDEX idx_game_event_player_id ON game_event(player_id);

CREATE INDEX idx_game_event_type ON game_event(event_type);

CREATE INDEX idx_player_team_id ON player(team_id);

CREATE INDEX idx_game_match_date ON game(match_date);