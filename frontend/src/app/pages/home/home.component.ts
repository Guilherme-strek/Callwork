import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { CallWorkApi } from '../../core/callwork-api.service';
import { ProfessionalSummary } from '../../core/models';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <section class="hero">
      <div class="container hero-grid">
        <div>
          <span class="badge badge-ok">+ de 12 mil profissionais verificados</span>
          <h1 class="h1" style="margin:16px 0 12px">
            O serviço que você precisa,<br /><span style="color:var(--brand-600)">perto de você.</span>
          </h1>
          <p class="muted" style="max-width:380px">
            Conecte-se a microempreendedores, autônomos e freelancers da sua região. Simples,
            acessível e seguro.
          </p>
          <div class="row" style="margin-top:24px;flex-wrap:wrap">
            <a routerLink="/buscar" class="btn btn-primary">Buscar serviços</a>
            <a routerLink="/cadastro" class="btn btn-ghost">Sou profissional</a>
          </div>
          <dl class="stats">
            <div><dt>12k+</dt><dd>Profissionais</dd></div>
            <div><dt>85k</dt><dd>Serviços feitos</dd></div>
            <div><dt>4,8★</dt><dd>Avaliação média</dd></div>
          </dl>
        </div>

        <ul class="featured stack">
          <li *ngFor="let p of destaques" class="card card-pad feat" [routerLink]="['/perfil', p.id]">
            <div class="avatar" [style.background]="'#e1f5ee'" style="width:44px;height:44px;color:#085041">
              {{ initials(p.name) }}
            </div>
            <div style="flex:1;min-width:0">
              <p style="font-weight:600">{{ p.name }} · {{ p.role }}</p>
              <p class="small muted"><span class="stars">★</span> {{ p.rating }} · {{ p.city }}</p>
            </div>
            <span class="badge" [class.badge-ok]="p.meiVerified" [class.badge-info]="!p.meiVerified">
              {{ p.meiVerified ? '✔ MEI' : '🔥 Em alta' }}
            </span>
          </li>
        </ul>
      </div>
    </section>

    <section class="container" style="padding:48px 20px">
      <h2 class="h2" style="text-align:center">Como funciona</h2>
      <div class="grid steps">
        <div class="card card-pad" *ngFor="let s of comoFunciona">
          <div style="font-size:1.6rem">{{ s.icon }}</div>
          <h3 style="margin:10px 0 4px;font-weight:700">{{ s.titulo }}</h3>
          <p class="muted small">{{ s.texto }}</p>
        </div>
      </div>
    </section>

    <section class="cta">
      <div class="container" style="text-align:center;padding:48px 20px">
        <h2 class="h2" style="color:#fff">Faça parte da economia local</h2>
        <p style="color:#cfd3cb;margin:10px auto 0;max-width:460px">
          Crie seu perfil, ganhe visibilidade e receba pedidos sem depender de intermediários.
        </p>
        <a routerLink="/cadastro" class="btn btn-primary" style="margin-top:22px">Criar meu perfil grátis</a>
      </div>
    </section>
  `,
  styles: [
    `
      .hero { background: linear-gradient(180deg, var(--paper), var(--brand-50)); }
      .hero-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; align-items: center; padding: 64px 20px; }
      .stats { display: flex; gap: 32px; margin-top: 36px; }
      .stats dt { font-size: 1.6rem; font-weight: 800; color: var(--brand-600); }
      .stats dd { font-size: 0.75rem; color: var(--ink-soft); }
      .feat { display: flex; align-items: center; gap: 12px; cursor: pointer; transition: 0.15s; }
      .feat:hover { transform: translateY(-2px); }
      .steps { grid-template-columns: repeat(3, 1fr); margin-top: 28px; }
      .cta { background: var(--ink); }
      @media (max-width: 820px) {
        .hero-grid { grid-template-columns: 1fr; }
        .steps { grid-template-columns: 1fr; }
      }
    `,
  ],
})
export class HomeComponent implements OnInit {
  destaques: ProfessionalSummary[] = [];
  comoFunciona = [
    { icon: '🔍', titulo: 'Busque', texto: 'Encontre profissionais por categoria e localização, com avaliações reais.' },
    { icon: '💬', titulo: 'Negocie', texto: 'Converse direto e receba uma proposta de serviço transparente.' },
    { icon: '⭐', titulo: 'Avalie', texto: 'Contrate com segurança e avalie ao final para ajudar a comunidade.' },
  ];

  constructor(private api: CallWorkApi) {}

  ngOnInit(): void {
    this.api.search('', 'Todos', false).subscribe((list) => (this.destaques = list.slice(0, 3)));
  }

  initials(name: string): string {
    return name.split(' ').map((n) => n[0]).slice(0, 2).join('').toUpperCase();
  }
}
