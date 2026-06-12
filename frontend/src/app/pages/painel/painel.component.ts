import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { forkJoin } from 'rxjs';
import { AuthService } from '../../core/auth.service';
import { CallWorkApi } from '../../core/callwork-api.service';
import { ServiceItem, ServiceRequestDto } from '../../core/models';

interface ServiceForm {
  id?: number;
  title: string;
  price: number | null;
  active: boolean;
}

@Component({
  selector: 'app-painel',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  template: `
    <div class="container" style="padding:24px 20px">
      <div class="layout">
        <aside class="card sidebar">
          <button
            *ngFor="let i of menu"
            class="menu-item"
            [class.on]="aba === i.id"
            (click)="aba = i.id"
          >
            <span aria-hidden="true">{{ i.icon }}</span> {{ i.label }}
          </button>
        </aside>

        <section>
          <div class="row header">
            <div>
              <h1 style="font-size:1.3rem;font-weight:800">Painel do profissional</h1>
              <a
                *ngIf="auth.professionalId"
                class="small panel-profile-link"
                [routerLink]="['/perfil', auth.professionalId]"
              >
                {{ auth.session?.name }}
              </a>
            </div>
            <button class="btn btn-primary btn-sm" (click)="novoServico()">+ Novo servico</button>
          </div>

          <p *ngIf="erro" class="err">{{ erro }}</p>
          <p *ngIf="carregando" class="muted small">Carregando...</p>

          <div class="grid two" style="margin-top:16px" *ngIf="!carregando">
            <div class="card card-pad">
              <h2 style="font-weight:700;margin-bottom:12px">Pedidos recebidos</h2>
              <div *ngFor="let r of pedidos" class="ped">
                <div style="min-width:0">
                  <p style="font-weight:600">{{ r.requesterName }}</p>
                  <p class="small muted">{{ r.serviceTitle }}</p>
                  <p class="small muted" *ngIf="r.message">{{ r.message }}</p>
                  <p class="small muted pay">{{ paymentLabel(r) }}</p>
                </div>
                <div class="row ped-actions">
                  <span class="badge" [ngClass]="statusClass(r.status)">{{ statusLabel(r.status) }}</span>
                  <span class="badge" [ngClass]="paymentClass(r.paymentStatus)">
                    {{ r.paymentStatus === 'PAID' ? 'Pago' : 'A pagar' }}
                  </span>
                  <ng-container *ngIf="r.status === 'PENDING'">
                    <button class="btn btn-primary btn-sm" (click)="atualizarPedido(r, 'CONFIRMED')">Aceitar</button>
                    <button class="btn btn-ghost btn-sm" (click)="atualizarPedido(r, 'DECLINED')">Recusar</button>
                  </ng-container>
                </div>
              </div>
              <p *ngIf="pedidos.length === 0" class="muted small">Nenhum pedido ainda.</p>
            </div>

            <div class="card card-pad">
              <h2 style="font-weight:700;margin-bottom:12px">Meus servicos</h2>

              <form class="service-form" (ngSubmit)="salvarServico()">
                <input class="input" name="title" [(ngModel)]="form.title" placeholder="Nome do servico" />
                <input
                  class="input"
                  name="price"
                  type="number"
                  min="1"
                  step="0.01"
                  [(ngModel)]="form.price"
                  placeholder="Preco R$"
                />
                <label class="check">
                  <input type="checkbox" name="active" [(ngModel)]="form.active" />
                  Ativo
                </label>
                <button class="btn btn-primary btn-sm" type="submit" [disabled]="salvando">
                  {{ form.id ? 'Salvar' : 'Adicionar' }}
                </button>
                <button class="btn btn-ghost btn-sm" type="button" (click)="novoServico()" *ngIf="form.id">
                  Cancelar
                </button>
              </form>

              <div *ngFor="let s of servicos" class="svc">
                <div>
                  <p style="font-weight:600">{{ s.title }}</p>
                  <p class="small muted">{{ s.price }}</p>
                </div>
                <div class="row svc-actions">
                  <span class="badge" [ngClass]="s.active ? 'badge-ok' : 'badge-muted'">
                    {{ s.active ? 'Ativo' : 'Pausado' }}
                  </span>
                  <button class="btn btn-ghost btn-sm" (click)="editarServico(s)">Editar</button>
                  <button class="btn btn-ghost btn-sm danger" (click)="excluirServico(s)">Excluir</button>
                </div>
              </div>
              <p *ngIf="servicos.length === 0" class="muted small">Nenhum servico cadastrado.</p>
            </div>
          </div>
        </section>
      </div>
    </div>
  `,
  styles: [
    `
      .layout { display: grid; grid-template-columns: 190px 1fr; gap: 20px; }
      .header { justify-content: space-between; align-items: center; margin-bottom: 16px; }
      .sidebar { background: var(--ink); padding: 14px; height: max-content; position: sticky; top: 76px; }
      .menu-item { display: flex; align-items: center; gap: 8px; width: 100%; text-align: left; padding: 9px 11px; border-radius: 8px; border: 0; background: transparent; color: #cfd3cb; font-size: 0.85rem; }
      .menu-item.on { background: rgba(255, 255, 255, 0.1); color: #fff; }
      .two { grid-template-columns: 1.2fr 1fr; }
      .ped, .svc { display: flex; align-items: center; justify-content: space-between; gap: 8px; padding: 10px 0; border-bottom: 1px solid var(--line); }
      .ped:last-child, .svc:last-child { border-bottom: 0; }
      .ped-actions, .svc-actions { gap: 8px; align-items: center; flex-wrap: wrap; justify-content: flex-end; }
      .panel-profile-link { color: var(--ink-soft); font-weight: 600; }
      .panel-profile-link:hover { color: var(--brand-600); text-decoration: underline; }
      .pay { margin-top: 4px; }
      .service-form { display: grid; grid-template-columns: 1fr 110px; gap: 8px; margin-bottom: 12px; }
      .check { display: flex; align-items: center; gap: 6px; font-size: 0.82rem; color: var(--ink-soft); }
      .danger { color: #b3261e; }
      .err { color: #b3261e; font-size: 0.85rem; margin-bottom: 10px; }
      @media (max-width: 900px) {
        .layout { grid-template-columns: 1fr; }
        .sidebar { position: static; display: flex; gap: 6px; overflow-x: auto; }
        .two { grid-template-columns: 1fr; }
      }
      @media (max-width: 560px) {
        .header, .ped, .svc { flex-direction: column; align-items: stretch; }
        .service-form { grid-template-columns: 1fr; }
        .ped-actions, .svc-actions { justify-content: flex-start; }
      }
    `,
  ],
})
export class PainelComponent implements OnInit {
  aba = 'painel';
  pedidos: ServiceRequestDto[] = [];
  servicos: ServiceItem[] = [];
  carregando = true;
  salvando = false;
  erro = '';
  form: ServiceForm = this.emptyForm();

  menu = [
    { id: 'painel', icon: 'P', label: 'Painel' },
    { id: 'pedidos', icon: '#', label: 'Pedidos' },
    { id: 'servicos', icon: '+', label: 'Servicos' },
  ];

  constructor(private api: CallWorkApi, public auth: AuthService) {}

  ngOnInit(): void {
    this.carregar();
  }

  carregar(): void {
    this.carregando = true;
    this.erro = '';
    const professionalId = this.auth.professionalId;
    if (!professionalId) {
      this.erro = 'Entre como profissional para acessar o painel.';
      this.carregando = false;
      return;
    }

    forkJoin({
      pedidos: this.api.listRequests(professionalId),
      servicos: this.api.listServices(professionalId),
    }).subscribe({
      next: ({ pedidos, servicos }) => {
        this.pedidos = pedidos;
        this.servicos = servicos;
        this.carregando = false;
      },
      error: () => {
        this.erro = 'Nao foi possivel carregar o painel.';
        this.carregando = false;
      },
    });
  }

  novoServico(): void {
    this.form = this.emptyForm();
  }

  editarServico(s: ServiceItem): void {
    this.form = {
      id: s.id,
      title: s.title,
      price: s.priceCents / 100,
      active: s.active,
    };
  }

  salvarServico(): void {
    if (!this.form.title.trim() || !this.form.price || this.form.price <= 0) {
      this.erro = 'Informe nome e preco do servico.';
      return;
    }

    this.salvando = true;
    this.erro = '';
    const payload = {
      title: this.form.title.trim(),
      priceCents: Math.round(this.form.price * 100),
      active: this.form.active,
    };
    const professionalId = this.auth.professionalId;
    if (!professionalId) {
      this.erro = 'Entre como profissional para salvar servicos.';
      this.salvando = false;
      return;
    }

    const request = this.form.id
      ? this.api.updateService(professionalId, this.form.id, payload)
      : this.api.createService(professionalId, payload);

    request.subscribe({
      next: () => {
        this.salvando = false;
        this.novoServico();
        this.carregar();
      },
      error: () => {
        this.salvando = false;
        this.erro = 'Nao foi possivel salvar o servico.';
      },
    });
  }

  excluirServico(s: ServiceItem): void {
    const professionalId = this.auth.professionalId;
    if (!professionalId) {
      this.erro = 'Entre como profissional para excluir servicos.';
      return;
    }

    this.api.deleteService(professionalId, s.id).subscribe({
      next: () => this.carregar(),
      error: () => (this.erro = 'Nao foi possivel excluir o servico.'),
    });
  }

  atualizarPedido(r: ServiceRequestDto, status: 'CONFIRMED' | 'DECLINED'): void {
    this.api.updateRequestStatus(r.id, status).subscribe({
      next: (updated) => Object.assign(r, updated),
      error: () => (this.erro = 'Nao foi possivel atualizar o pedido.'),
    });
  }

  statusLabel(s: string): string {
    return s === 'PENDING' ? 'Pendente' : s === 'CONFIRMED' ? 'Confirmado' : 'Recusado';
  }

  statusClass(s: string): string {
    return s === 'PENDING' ? 'badge-warn' : s === 'CONFIRMED' ? 'badge-ok' : 'badge-muted';
  }

  paymentLabel(r: ServiceRequestDto): string {
    return r.paymentStatus === 'PAID'
      ? `Pagamento recebido${r.paymentMethod ? ` via ${r.paymentMethod}` : ''}.`
      : 'Aguardando pagamento do cliente.';
  }

  paymentClass(s: ServiceRequestDto['paymentStatus']): string {
    return s === 'PAID' ? 'badge-ok' : 'badge-warn';
  }

  private emptyForm(): ServiceForm {
    return { title: '', price: null, active: true };
  }
}
