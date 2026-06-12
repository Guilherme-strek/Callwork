import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { AuthService } from '../../core/auth.service';
import { CallWorkApi } from '../../core/callwork-api.service';
import { ProfessionalDetail } from '../../core/models';

@Component({
  selector: 'app-perfil',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="container" style="padding:24px 20px" *ngIf="pro as p">
      <a routerLink="/buscar" class="small muted">Voltar para a busca</a>

      <div class="layout" style="margin-top:16px">
        <div class="stack">
          <div class="card card-pad row" style="align-items:center">
            <div class="avatar" style="width:64px;height:64px;font-size:1.2rem;background:#e1f5ee;color:#085041">
              {{ initials(p.name) }}
            </div>
            <div>
              <div class="row" style="align-items:center;gap:10px;flex-wrap:wrap">
                <h1 style="font-size:1.4rem;font-weight:800">{{ p.name }}</h1>
                <span *ngIf="p.meiVerified" class="badge badge-ok">MEI verificado</span>
              </div>
              <p class="small muted" style="margin-top:2px">{{ p.role }} · {{ p.city }}</p>
              <p class="small muted" style="margin-top:4px">
                <span class="stars">★★★★★</span> {{ p.rating }} · {{ p.reviewsCount }} avaliações
              </p>
            </div>
          </div>

          <div class="card card-pad">
            <h2 style="font-weight:700;margin-bottom:8px">Sobre</h2>
            <p class="muted small" style="line-height:1.6">{{ p.about || 'Sem descrição.' }}</p>
          </div>

          <div class="card card-pad">
            <h2 style="font-weight:700;margin-bottom:12px">Avaliações de clientes</h2>
            <div *ngFor="let r of p.reviews" class="review">
              <p class="small"><span class="stars">★★★★★</span> <strong>{{ r.author }}</strong></p>
              <p class="small muted" style="margin-top:2px">{{ r.comment }}</p>
            </div>
            <p *ngIf="p.reviews.length === 0" class="muted small">Ainda sem avaliações.</p>
          </div>
        </div>

        <aside class="stack sticky">
          <div class="card card-pad">
            <h2 style="font-weight:700;margin-bottom:12px">Serviços e preços</h2>
            <div *ngFor="let s of p.services" class="svc">
              <span>{{ s.title }}</span><strong>{{ s.price }}</strong>
            </div>
            <p *ngIf="p.services.length === 0" class="muted small">Nenhum serviço ativo cadastrado.</p>

            <button class="btn btn-primary btn-block" style="margin-top:14px" (click)="solicitar(p)">
              Solicitar serviço
            </button>
            <button class="btn btn-ghost btn-block" style="margin-top:8px" (click)="solicitar(p)">
              Enviar mensagem
            </button>

            <p *ngIf="!auth.isLoggedIn" class="small muted" style="margin-top:10px">
              Entre como cliente para solicitar ou enviar mensagem.
            </p>
            <p *ngIf="enviado" class="small ok">Solicitação enviada. O profissional verá no painel.</p>
            <p *ngIf="erroSolicitacao" class="small err">{{ erroSolicitacao }}</p>
          </div>

          <div class="card card-pad small muted">
            <p style="font-weight:700;color:var(--ink);margin-bottom:6px">Atende em</p>
            <p>{{ p.city }}</p>
            <p style="margin-top:4px">Seg a sáb · 8h às 18h</p>
          </div>
        </aside>
      </div>
    </div>

    <p *ngIf="!pro && !erro" class="container muted" style="padding:40px 20px">Carregando...</p>
    <p *ngIf="erro" class="container" style="padding:40px 20px">
      Profissional não encontrado. <a routerLink="/buscar" style="color:var(--brand-600)">Voltar à busca</a>
    </p>
  `,
  styles: [
    `
      .layout { display: grid; grid-template-columns: 1.6fr 1fr; gap: 20px; }
      .sticky { position: sticky; top: 76px; align-self: start; }
      .review { padding: 10px 0; border-bottom: 1px solid var(--line); }
      .review:last-child { border-bottom: 0; }
      .svc { display: flex; justify-content: space-between; font-size: 0.9rem; padding: 8px 0; border-bottom: 1px solid var(--line); gap: 12px; }
      .svc:last-of-type { border-bottom: 0; }
      .ok { color: var(--brand-700); margin-top: 10px; }
      .err { color: #b3261e; margin-top: 10px; }
      @media (max-width: 820px) {
        .layout { grid-template-columns: 1fr; }
        .sticky { position: static; }
      }
    `,
  ],
})
export class PerfilComponent implements OnInit {
  pro?: ProfessionalDetail;
  erro = false;
  enviado = false;
  erroSolicitacao = '';

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private api: CallWorkApi,
    public auth: AuthService
  ) {}

  ngOnInit(): void {
    const id = Number(this.route.snapshot.paramMap.get('id'));
    this.api.getById(id).subscribe({
      next: (p) => (this.pro = p),
      error: () => (this.erro = true),
    });
  }

  solicitar(p: ProfessionalDetail): void {
    const session = this.auth.session;
    if (!session) {
      this.router.navigate(['/login'], { queryParams: { returnUrl: `/perfil/${p.id}`, mode: 'customer' } });
      return;
    }

    if (session.role !== 'CUSTOMER' || !session.customerId) {
      this.erroSolicitacao = 'Use uma conta de cliente para solicitar servico.';
      return;
    }

    this.erroSolicitacao = '';
    const titulo = p.services[0]?.title ?? 'Serviço';
    this.api
      .requestService(p.id, {
        requesterName: session.name,
        serviceTitle: titulo,
        message: 'Tenho interesse neste serviço.',
      })
      .subscribe({
        next: () => (this.enviado = true),
        error: () => (this.erroSolicitacao = 'Não foi possível enviar a solicitação.'),
      });
  }

  initials(name: string): string {
    return name.split(' ').map((n) => n[0]).slice(0, 2).join('').toUpperCase();
  }
}
