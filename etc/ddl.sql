CREATE TABLE stocks (
    id SERIAL PRIMARY KEY,
    day DATE NOT NULL,
    ticker TEXT NOT NULL,
    open NUMERIC(5,2) NOT NULL,
    high NUMERIC(5,2) NOT NULL,
    low NUMERIC(5,2) NOT NULL,
    close NUMERIC(5,2) NOT NULL,
    volume INTEGER NOT NULL
);

CREATE INDEX day_idx ON stocks (day);
CREATE INDEX ticker_idx ON stocks (ticker);
