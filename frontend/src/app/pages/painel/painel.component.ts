import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CallWorkApi } from '../../core/callwork-api.service';
import { ServiceRequestDto } from '../../core/models';

@Component({
  selector: 'app-painel',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="container" style="padding:24px 20px">
      <div class="layout">
        <aside class="card sidebar">
          <button *ngFor="let i of menu" class="menu-item" [class.on]="i.on">
            <span aria-hidden="true">{{ i.icon }}</span> {{ i.label }}
          </button>
        </aside>

        <section>
          <div class="row" style="justify-content:space-between;align-items:center;margin-bottom:16px">
            <div>
              <h1 style="font-size:1.3rem;font-weight:800">Olá, Ana 👋</h1>
              <p class="small muted">Resumo de junho</p>
            </div>
            <button class="btn btn-primary btn-sm">+ Novo serviço</button>
          </div>

          <div class="kpis">
            <div class="card card-pad" *ngFor="let k of kpis">
              <p class="small muted">{{ k.label }}</p>
              <p style="font-size:1.4rem;font-weight:800">{{ k.value }}</p>
              <p class="small" [style.color]="k.color || 'var(--ink-soft)'">{{ k.sub }}</p>
            </div>
          </div>

          <div class="grid two" style="margin-top:16px">
            <div class="card card-pad">
              <h2 style="font-weight:700;margin-bottom:12px">Pedidos recebidos</h2>
              <p *ngIf="carregando" class="muted small">Carregando…</p>
              <div *ngFor="let r of pedidos" class="ped">
                <div style="min-width:0">
                  <p style="font-weight:600">{{ r.requesterName }}</p>
                  <p class="small muted">{{ r.serviceTitle }}</p>
                </div>
                <div class="row" style="align-items:center;gap:8px">
                  <span class="badge" [ngClass]="statusClass(r.status)">{{ statusLabel(r.status) }}</span>
                  <ng-container *ngIf="r.status === 'PENDING'">
                    <button class="btn btn-primary btn-sm" (click)="atualizar(r, 'CONFIRMED')">Aceitar</button>
                    <button class="btn btn-ghost btn-sm" (click)="atualizar(r, 'DECLINED')">Recusar</button>
                  </ng-container>
                </div>
              </div>
              <p *ngIf="!carregando && pedidos.length === 0" class="muted small">Nenhum pedido ainda.</p>
            </div>

            <div class="card card-pad">
              <h2 style="font-weight:700;margin-bottom:12px">Meus serviços</h2>
              <div *ngFor="let s of servicos" class="svc">
                <span>{{ s.nome }}</span>
                <span class="badge" [ngClass]="s.ativo ? 'badge-ok' : 'badge-muted'">{{ s.ativo ? 'Ativo' : 'Pausado' }}</span>
              </div>
            </div>
          </div>
        </section>
      </div>
    </div>
  `,
  styles: [
    `
      .layout { display: grid; grid-template-columns: 190px 1fr; gap: 20px; }
      .sidebar { background: var(--ink); padding: 14px; height: max-content; position: sticky; top: 76px; }
      .menu-item { display: flex; align-items: center; gap: 8px; width: 100%; text-align: left; padding: 9px 11px; border-radius: 8px; border: 0; background: transparent; color: #cfd3cb; font-size: 0.85rem; }
      .menu-item.on { background: rgba(255, 255, 255, 0.1); color: #fff; }
      .kpis { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; }
      .two { grid-template-columns: 1.4fr 1fr; }
      .ped { display: flex; align-items: center; justify-content: space-between; gap: 8px; padding: 10px 0; border-bottom: 1px solid var(--line); }
      .ped:last-child { border-bottom: 0; }
      .svc { display: flex; justify-content: space-between; align-items: center; font-size: 0.9rem; padding: 8px 0; border-bottom: 1px solid var(--line); }
      .svc:last-child { border-bottom: 0; }
      @media (max-width: 900px) {
        .layout { grid-template-columns: 1fr; }
        .sidebar { position: static; display: flex; gap: 6px; overflow-x: auto; }
        .kpis { grid-template-columns: repeat(2, 1fr); }
        .two { grid-template-columns: 1fr; }
      }
    `,
  ],
})
export class PainelComponent implements OnInit {
  // No app real, o id viria do usuário autenticado. Aqui usamos a profissional 1 (Ana).
  private readonly professionalId = 1;
  pedidos: ServiceRequestDto[] = [];
  carregando = true;

  menu = [
    { icon: '🏠', label: 'Painel', on: true },
    { icon: '📋', label: 'Pedidos', on: false },
    { icon: '🧰', label: 'Meus serviços', on: false },
    { icon: '💬', label: 'Conversas', on: false },
    { icon: '⭐', label: 'Avaliações', on: false },
    { icon: '👤', label: 'Meu perfil', on: false },
  ];
  kpis = [
    { label: 'Ganhos do mês', value: 'R$ 2.480', sub: '▲ 18% vs maio', color: 'var(--brand-700)' },
    { label: 'Serviços', value: '14', sub: 'concluídos' },
    { label: 'Avaliação', value: '4,9★', sub: '132 no total' },
    { label: 'Resposta', value: '98%', sub: '~1h em média' },
  ];
  servicos = [
    { nome: 'Limpeza residencial', ativo: true },
    { nome: 'Limpeza pós-obra', ativo: true },
    { nome: 'Limpeza comercial', ativo: false },
  ];

  constructor(private api: CallWorkApi) {}

  ngOnInit(): void {
    this.carregar();
  }

  carregar(): void {
    this.carregando = true;
    this.api.listRequests(this.professionalId).subscribe((list) => {
      this.pedidos = list;
      this.carregando = false;
    });
  }

  atualizar(r: ServiceRequestDto, status: 'CONFIRMED' | 'DECLINED'): void {
    this.api.updateRequestStatus(r.id, status).subscribe((updated) => (r.status = updated.status));
  }

  statusLabel(s: string): string {
    return s === 'PENDING' ? 'Pendente' : s === 'CONFIRMED' ? 'Confirmado' : 'Recusado';
  }
  statusClass(s: string): string {
    return s === 'PENDING' ? 'badge-warn' : s === 'CONFIRMED' ? 'badge-ok' : 'badge-muted';
  }
}
