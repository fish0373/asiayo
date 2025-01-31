SELECT
	`class`.`name` AS name, 
	`class`.`class` AS class, 
	`score`.`score` AS score 
FROM `class`
LEFT JOIN `score` ON `class`.`name` = `score`.`name`
ORDER BY score DESC
LIMIT 1, 1