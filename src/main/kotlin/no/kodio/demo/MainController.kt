package no.kodio.demo

import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class MainController(val jdbcTemplate: JdbcTemplate) {

    @GetMapping("/")
    fun index(): List<String> {
        return jdbcTemplate.queryForList("SELECT * FROM demo").stream()
            .map {
                it.values.toString()
            }.toList();
    }
}