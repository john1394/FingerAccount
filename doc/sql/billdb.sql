  -- amount 是分钱，是个整数
  CREATE TABLE IF NOT EXISTS bills (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    amount INTEGER,
    category TEXT,
    timestamp INTEGER,
    notes TEXT,
    extra_fields TEXT
  );

  CREATE TABLE IF NOT EXISTS aggregations (
      type TEXT,
      date_key TEXT,
      total_amount INTEGER,
      category TEXT,
      PRIMARY KEY (type, date_key)
      );

CREATE INDEX idx_bills_timestamp ON bills(timestamp);       -- 加速时间范围查询
CREATE INDEX idx_bills_category ON bills(category);        -- 加速分类过滤
CREATE INDEX idx_aggregations_date ON aggregations(date_key);

--
--CREATE TABLE bill_extensions (
--  bill_id INTEGER,       -- 关联 bills.id
--  key TEXT,               -- 字段名（如 "shop"）
--  value TEXT,             -- 字段值（如 "星巴克"）
--  FOREIGN KEY(bill_id) REFERENCES bills(id));
--
--CREATE INDEX idx_extensions_key ON bill_extensions(key);