package com.callwork.api.config;

import com.callwork.api.model.*;
import com.callwork.api.repository.*;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.List;

@Component
public class DataInitializer implements CommandLineRunner {

    private final ProfessionalRepository professionals;
    private final ServiceRepository services;
    private final ReviewRepository reviews;
    private final ServiceRequestRepository requests;

    public DataInitializer(ProfessionalRepository professionals,
                           ServiceRepository services,
                           ReviewRepository reviews,
                           ServiceRequestRepository requests) {
        this.professionals = professionals;
        this.services = services;
        this.reviews = reviews;
        this.requests = requests;
    }

    @Override
    public void run(String... args) {
        if (professionals.count() > 0) return;

        Professional ana = professionals.save(Professional.builder()
                .name("Ana Moura").role("Diarista").category("Limpeza").city("Maringá, PR")
                .about("Diarista com 6 anos de experiência em limpeza residencial e comercial. Pontual e com produtos próprios.")
                .cnpj("12.345.678/0001-90").meiVerified(true)
                .rating(new BigDecimal("4.9")).reviewsCount(132).build());

        Professional carlos = professionals.save(Professional.builder()
                .name("Carlos Reis").role("Eletricista").category("Reformas").city("Maringá, PR")
                .about("Eletricista predial e residencial. Instalações, manutenção e laudos. Atende emergências.")
                .cnpj("23.456.789/0001-01").meiVerified(true)
                .rating(new BigDecimal("4.8")).reviewsCount(87).build());

        Professional julia = professionals.save(Professional.builder()
                .name("Júlia Souza").role("Designer freelancer").category("Tecnologia").city("Remoto")
                .about("Designer gráfica focada em identidade visual para pequenos negócios.")
                .meiVerified(false).rating(new BigDecimal("5.0")).reviewsCount(41).build());

        Professional rosa = professionals.save(Professional.builder()
                .name("Rosa Lima").role("Diarista").category("Limpeza").city("Maringá, PR")
                .about("Diarista atenta aos detalhes, especializada em limpeza pesada e organização de ambientes.")
                .cnpj("34.567.890/0001-12").meiVerified(true)
                .rating(new BigDecimal("4.7")).reviewsCount(64).build());

        Professional clara = professionals.save(Professional.builder()
                .name("Clara Freitas").role("Manicure").category("Beleza").city("Maringá, PR")
                .about("Manicure e designer de sobrancelhas com atendimento a domicílio.")
                .cnpj("45.678.901/0001-23").meiVerified(true)
                .rating(new BigDecimal("4.8")).reviewsCount(91).build());

        services.saveAll(List.of(
                service(ana, "Limpeza residencial", 12000, true),
                service(ana, "Limpeza pós-obra", 18000, true),
                service(ana, "Limpeza comercial", 15000, false),
                service(carlos, "Instalação de tomadas", 9000, true),
                service(carlos, "Troca de disjuntor", 12000, true),
                service(carlos, "Laudo elétrico", 25000, true),
                service(julia, "Logo + manual de marca", 45000, true),
                service(julia, "Kit social media", 28000, true),
                service(rosa, "Limpeza residencial", 11000, true),
                service(rosa, "Faxina pesada", 16000, true),
                service(clara, "Mãos e pés", 6000, true),
                service(clara, "Design de sobrancelha", 4000, true)
        ));

        reviews.saveAll(List.of(
                review(ana, "Padaria do Bairro", 5, "Pontual e caprichosa, contratei de novo sem pensar duas vezes."),
                review(ana, "TechLocal MEI", 5, "Ótimo trabalho na limpeza do nosso escritório. Recomendo!"),
                review(carlos, "Mercado Central", 5, "Resolveu o problema elétrico rapidinho."),
                review(rosa, "Condomínio Jardim", 4, "Trabalho bem feito, voltarei a chamar.")
        ));

        requests.saveAll(List.of(
                request(ana, "Padaria do Bairro", "Limpeza comercial", "Você atende sexta às 14h?", ServiceRequest.Status.PENDING),
                request(ana, "TechLocal MEI", "Limpeza pós-obra", "Confirmado para segunda 9h.", ServiceRequest.Status.CONFIRMED)
        ));
    }

    private Service service(Professional p, String title, int priceCents, boolean active) {
        return Service.builder().professional(p).title(title).priceCents(priceCents).active(active).build();
    }

    private Review review(Professional p, String author, int rating, String comment) {
        return Review.builder().professional(p).author(author).rating((short) rating).comment(comment).build();
    }

    private ServiceRequest request(Professional p, String requester, String title, String msg, ServiceRequest.Status status) {
        return ServiceRequest.builder().professional(p).requesterName(requester)
                .serviceTitle(title).message(msg).status(status).build();
    }
}
