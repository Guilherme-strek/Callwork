import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService } from '../../core/api.service';
import { ServiceRequestDto } from '../../core/models';

@Component({
  selector: 'app-painel',
  standalone: true,
  imports: [CommonModule],
  template: `
    <header class="top-nav" style="justify-content:space-between">
      <div class="logo">
        <span class="logo-mark">☎</span> Call Work
      </div>
      <div class="avatar" style="width:32px;height:32px;background:var(--brand-500);color:#fff;font-size:.75rem">AM</div>
    </header>

    <div class="page" style="padding-top:20px">

      <div style="margin-bottom:20px">
        <p style="font-size:1.2rem;font-weight:800">Olá, Ana 👋</p>
        <p class="small muted">Resumo de junho</p>
      </div>

      <div class="kpi-grid" style="margin-bottom:20px">
        <div class="kpi-card">
          <p class="kpi-label">Ganhos do mês</p>
          <p class="kpi-val" style="color:var(--brand-700)">R$ 2.480</p>
          <p class="small" style="color:var(--brand-600);margin-top:3px">▲ 18% vs maio</p>
        </div>
        <div class="kpi-card">
          <p class="kpi-label">Serviços</p>
          <p class="kpi-val">14</p>
          <p class="small muted" style="margin-top:3px">concluídos</p>
        </div>
        <div class="kpi-card">
          <p class="kpi-label">Avaliação</p>
          <p class="kpi-val">4,9<span class="stars" style="font-size:.85rem">★</span></p>
          <p class="small muted" style="margin-top:3px">132 no total</p>
        </div>
        <div class="kpi-card">
          <p class="kpi-label">Resposta</p>
          <p class="kpi-val">98%</p>
          <p class="small muted" style="margin-top:3px">~1h em média</p>
        </div>
      </div>

      <div class="card card-pad" style="margin-bottom:14px">
        <p class="sec-title">Pedidos recebidos</p>
        <p *ngIf="carregando" class="muted small" style="text-align:center;padding:14px 0">Carregando...</p>
        <div class="req-row" *ngFor="let r of pedidos">
          <div style="min-width:0;flex:1">
            <p style="font-size:.88rem;font-weight:700">{{ r.requesterName }}</p>
            <p class="small muted">{{ r.serviceTitle }}</p>
          </div>
          <div style="display:flex;flex-direction:column;align-items:flex-end;gap:6px">
            <span class="badge" [ngClass]="statusClass(r.status)">{{ statusLabel(r.status) }}</span>
            <div *ngIf="r.status==='PENDING'" style="display:flex;gap:5px">
              <button class="btn btn-primary btn-sm" (click)="atualizar(r,'CONFIRMED')">Aceitar</button>
              <button class="btn btn-ghost btn-sm" (click)="atualizar(r,'DECLINED')">Recusar</button>
            </div>
          </div>
        </div>
        <p *ngIf="!carregando && pedidos.length===0" class="muted small" style="text-align:center;padding:14px 0">Nenhum pedido ainda.</p>
      </div>

      <div class="card card-pad" style="margin-bottom:14px">
        <p class="sec-title">Meus serviços</p>
        <div class="svc-row" *ngFor="let s of servicos">
          <span style="font-size:.88rem">{{ s.nome }}</span>
          <span class="badge" [class.badge-ok]="s.ativo" [class.badge-muted]="!s.ativo">{{ s.ativo ? 'Ativo' : 'Pausado' }}</span>
        </div>
      </div>

    </div>
  `,
})
export class PainelComponent implements OnInit {
  private readonly professionalId = 1;
  pedidos: ServiceRequestDto[] = [];
  carregando = true;

  servicos = [
    { nome: 'Limpeza residencial', ativo: true },
    { nome: 'Limpeza pós-obra', ativo: true },
    { nome: 'Limpeza comercial', ativo: false },
  ];

  constructor(private api: ApiService) {}

  ngOnInit() {
    this.api.listRequests(this.professionalId).subscribe({
      next: list => { this.pedidos = list; this.carregando = false; },
      error: () => this.carregando = false
    });
  }

  atualizar(r: ServiceRequestDto, status: 'CONFIRMED' | 'DECLINED') {
    this.api.updateRequestStatus(r.id, status).subscribe(updated => r.status = updated.status);
  }

  statusLabel(s: string) { return s === 'PENDING' ? 'Pendente' : s === 'CONFIRMED' ? 'Confirmado' : 'Recusado'; }
  statusClass(s: string) { return s === 'PENDING' ? 'badge-warn' : s === 'CONFIRMED' ? 'badge-ok' : 'badge-muted'; }
}
