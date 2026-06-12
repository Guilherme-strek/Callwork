import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { ApiService } from '../../core/api.service';
import { ProfessionalDetail } from '../../core/models';

@Component({
  selector: 'app-perfil',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <!-- Header verde com info do profissional -->
    <div style="background:var(--brand-900);padding-top:env(safe-area-inset-top,0px)">
      <div style="display:flex;align-items:center;gap:12px;padding:14px 16px 0">
        <a routerLink="/buscar" style="color:#9FE1CB;font-size:.82rem;display:flex;align-items:center;gap:4px">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><polyline points="15 18 9 12 15 6"/></svg>
          Buscar
        </a>
      </div>

      <div *ngIf="pro as p" style="padding:16px 16px 24px;display:flex;align-items:center;gap:14px">
        <div class="avatar" style="width:60px;height:60px;background:#1D9E75;color:#fff;font-size:1.1rem;font-weight:800">
          {{ initials(p.name) }}
        </div>
        <div style="flex:1;min-width:0">
          <div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;margin-bottom:4px">
            <span style="font-size:1.1rem;font-weight:800;color:#fff">{{ p.name }}</span>
            <span *ngIf="p.meiVerified" class="badge badge-ok">✓ MEI</span>
          </div>
          <p style="font-size:.82rem;color:#9FE1CB">{{ p.role }} · {{ p.city }}</p>
          <p style="font-size:.82rem;color:#9FE1CB;margin-top:3px">
            <span class="stars">★</span> {{ p.rating }} · {{ p.reviewsCount }} avaliações · ~1h resposta
          </p>
        </div>
      </div>
    </div>

    <!-- Carregando / erro -->
    <p *ngIf="!pro && !erro" class="muted small" style="text-align:center;padding:40px 20px">Carregando...</p>
    <div *ngIf="erro" class="page empty">
      Profissional não encontrado.
      <a routerLink="/buscar" style="color:var(--brand-600);display:block;margin-top:8px">← Voltar à busca</a>
    </div>

    <div *ngIf="pro as p" class="page" style="padding-top:18px">

      <!-- Sobre -->
      <div class="card card-pad" style="margin-bottom:12px">
        <p class="sec-title">Sobre</p>
        <p style="font-size:.88rem;line-height:1.6;color:var(--ink-soft)">{{ p.about }}</p>
      </div>

      <!-- Serviços -->
      <div class="card card-pad" style="margin-bottom:12px">
        <p class="sec-title">Serviços e preços</p>
        <div class="svc-row" *ngFor="let s of p.services">
          <span style="font-size:.88rem">{{ s.title }}</span>
          <strong style="font-size:.88rem;color:var(--brand-700)">{{ s.price }}</strong>
        </div>
        <p *ngIf="p.services.length===0" class="muted small" style="text-align:center;padding:10px 0">Sem serviços cadastrados.</p>
      </div>

      <!-- Botão solicitar -->
      <button class="btn btn-primary btn-block" style="margin-bottom:10px" (click)="solicitar(p)" [disabled]="enviando">
        {{ enviando ? 'Enviando...' : '📅 Solicitar serviço' }}
      </button>
      <p *ngIf="enviado" style="text-align:center;color:var(--brand-700);font-size:.85rem;font-weight:700;margin-bottom:14px">
        ✓ Solicitação enviada! O profissional verá no painel.
      </p>

      <!-- Atendimento -->
      <div class="card card-pad" style="margin-bottom:12px;font-size:.85rem;color:var(--ink-soft)">
        <p style="font-weight:700;color:var(--ink);margin-bottom:8px">Atendimento</p>
        <p>📍 {{ p.city }} (até 20 km)</p>
        <p style="margin-top:6px">🗓 Seg a sáb · 8h às 18h</p>
      </div>

      <!-- Avaliações -->
      <div class="card card-pad" style="margin-bottom:20px">
        <p class="sec-title">Avaliações ({{ p.reviews.length }})</p>
        <div class="review-item" *ngFor="let r of p.reviews">
          <p style="font-size:.85rem;font-weight:700"><span class="stars">★★★★★</span> {{ r.author }}</p>
          <p style="font-size:.82rem;color:var(--ink-soft);margin-top:4px;line-height:1.5">{{ r.comment }}</p>
        </div>
        <p *ngIf="p.reviews.length===0" class="muted small" style="text-align:center;padding:10px 0">Ainda sem avaliações.</p>
      </div>

    </div>
  `,
})
export class PerfilComponent implements OnInit {
  pro?: ProfessionalDetail;
  erro = false;
  enviando = false;
  enviado = false;

  constructor(private route: ActivatedRoute, private api: ApiService) {}

  ngOnInit() {
    const id = Number(this.route.snapshot.paramMap.get('id'));
    this.api.getById(id).subscribe({ next: p => this.pro = p, error: () => this.erro = true });
  }

  solicitar(p: ProfessionalDetail) {
    if (this.enviado) return;
    this.enviando = true;
    const titulo = p.services[0]?.title ?? 'Serviço';
    this.api.requestService(p.id, {
      requesterName: 'Cliente App',
      serviceTitle: titulo,
      message: 'Tenho interesse neste serviço.',
    }).subscribe({ next: () => { this.enviado = true; this.enviando = false; }, error: () => this.enviando = false });
  }

  initials(name: string) { return name.split(' ').map(n => n[0]).slice(0, 2).join('').toUpperCase(); }
}
