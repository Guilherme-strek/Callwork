package com.callwork.api;

import com.callwork.api.dto.*;
import com.callwork.api.service.CallWorkService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Teste de integracao usando H2 em memoria (perfil de teste).
 * O schema e criado pelo Flyway a partir das migrations.
 */
@SpringBootTest
@TestPropertySource(properties = {
        "spring.datasource.url=jdbc:h2:mem:callwork;MODE=PostgreSQL;DB_CLOSE_DELAY=-1",
        "spring.datasource.driver-class-name=org.h2.Driver",
        "spring.datasource.username=sa",
        "spring.datasource.password=",
        "spring.flyway.enabled=true"
})
class CallWorkServiceTest {

    @Autowired
    CallWorkService service;

    @Test
    void buscaRetornaProfissionaisDoSeed() {
        List<ProfessionalSummaryDto> todos = service.search(null, "Todos", false);
        assertThat(todos).isNotEmpty();
    }

    @Test
    void filtroMeiOnlyExcluiAutonomosSemMei() {
        List<ProfessionalSummaryDto> meiOnly = service.search(null, null, true);
        assertThat(meiOnly).allMatch(ProfessionalSummaryDto::meiVerified);
    }

    @Test
    void cadastroComCnpjMarcaMeiVerificado() {
        var req = new CreateProfessionalRequest(
                "Teste Silva", "Pintor", "Reformas", "Maringá, PR",
                "Pinturas residenciais", "11.111.111/0001-11");
        ProfessionalDetailDto criado = service.create(req);
        assertThat(criado.meiVerified()).isTrue();
        assertThat(criado.id()).isNotNull();
    }

    @Test
    void cadastroSemCnpjFicaComoAutonomo() {
        var req = new CreateProfessionalRequest(
                "Sem Cnpj", "Jardineiro", "Reformas", "Maringá, PR", "Jardins", "");
        ProfessionalDetailDto criado = service.create(req);
        assertThat(criado.meiVerified()).isFalse();
    }
}
