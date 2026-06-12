import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ApiService } from '../../core/api.service';
import { ProfessionalSummary } from '../../core/models';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <header class="top-nav">
      <div class="logo">
        <span class="logo-mark">☎</span> Call Work
      </div>
    </header>

    <section class="hero-section">
      <span class="badge badge-ok" style="margin-bottom:14px;display:inline-flex">✓ +12 mil profissionais verificados</span>
      <h1>O serviço que você precisa, <span style="color:#86d9bb">perto de você.</span></h1>
      <p>Conecte-se a microempreendedores e autônomos da sua região.</p>
      <div style="display:flex;flex-direction:column;gap:10px">
        <a routerLink="/buscar" class="btn btn-primary btn-block">Buscar serviços</a>
        <a routerLink="/cadastro" class="btn btn-ghost btn-block" style="background:rgba(255,255,255,.1);color:#fff;border-color:rgba(255,255,255,.2)">Sou profissional</a>
      </div>
      <dl class="hero-stats">
        <div class="hero-stat"><dt>12k+</dt><dd>Profissionais</dd></div>
        <div class="hero-stat"><dt>85k</dt><dd>Serviços</dd></div>
        <div class="hero-stat"><dt>4,8★</dt><dd>Avaliação</dd></div>
      </dl>
    </section>

    <div class="page" style="padding-top:20px">

      <p class="sec-title">Em destaque</p>
      <div class="stack">
        <a *ngFor="let p of destaques" [routerLink]="['/perfil', p.id]" class="pro-card">
          <div class="avatar" style="width:46px;height:46px;background:#e1f5ee;color:#085041;font-size:.85rem">
            {{ initials(p.name) }}
          </div>
          <div style="flex:1;min-width:0">
            <p class="pro-name">{{ p.name }}</p>
            <p class="pro-sub">{{ p.role }} · {{ p.city }}</p>
            <p class="pro-sub" style="margin-top:3px"><span class="stars">★</span> {{ p.rating }} · {{ p.reviewsCount }} aval.</p>
          </div>
          <div style="display:flex;flex-direction:column;align-items:flex-end;gap:6px">
            <span class="badge" [class.badge-ok]="p.meiVerified" [class.badge-muted]="!p.meiVerified">
              {{ p.meiVerified ? '✓ MEI' : 'Autônomo' }}
            </span>
            <span *ngIf="p.startingPrice" style="font-size:.78rem;font-weight:700;color:#085041">{{ p.startingPrice }}</span>
          </div>
        </a>
        <p *ngIf="destaques.length === 0" class="muted small" style="text-align:center;padding:20px 0">Carregando...</p>
      </div>
      <a routerLink="/buscar" class="btn btn-ghost btn-block" style="margin-top:14px">Ver todos →</a>

      <div class="divider" style="margin:24px 0"></div>

      <p class="sec-title">Como funciona</p>
      <div class="stack">
        <div class="card card-pad" *ngFor="let s of passos" style="display:flex;align-items:flex-start;gap:14px">
          <span style="font-size:1.4rem;flex-shrink:0">{{ s.icon }}</span>
          <div>
            <p class="h3" style="margin-bottom:4px">{{ s.titulo }}</p>
            <p class="small muted">{{ s.texto }}</p>
          </div>
        </div>
      </div>

      <div class="card card-pad" style="margin-top:20px;background:var(--brand-900);border-color:var(--brand-900);text-align:center">
        <p style="font-size:1.05rem;font-weight:800;color:#fff;margin-bottom:6px">Faça parte da economia local</p>
        <p style="font-size:.82rem;color:#9FE1CB;margin-bottom:14px">Crie seu perfil e comece a receber pedidos.</p>
        <a routerLink="/cadastro" class="btn btn-primary btn-block">Criar perfil grátis</a>
      </div>

    </div>
  `,
})
export class HomeComponent implements OnInit {
  destaques: ProfessionalSummary[] = [];
  passos = [
    { icon: '🔍', titulo: 'Busque', texto: 'Encontre profissionais por categoria e localização.' },
    { icon: '💬', titulo: 'Negocie', texto: 'Converse direto e receba uma proposta transparente.' },
    { icon: '⭐', titulo: 'Avalie', texto: 'Contrate com segurança e avalie para ajudar a comunidade.' },
  ];

  constructor(private api: ApiService) {}

  ngOnInit() {
    this.api.search('', 'Todos', false).subscribe({ next: list => this.destaques = list.slice(0, 4) });
  }

  initials(name: string) {
    return name.split(' ').map(n => n[0]).slice(0, 2).join('').toUpperCase();
  }
}
