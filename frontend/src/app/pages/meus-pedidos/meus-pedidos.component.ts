import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { AuthService } from '../../core/auth.service';
import { CallWorkApi } from '../../core/callwork-api.service';
import { ServiceRequestDto } from '../../core/models';

@Component({
  selector: 'app-meus-pedidos',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="container narrow" style="padding:24px 20px">
      <div class="row header">
        <div>
          <h1 style="font-size:1.3rem;font-weight:800">Meus pedidos</h1>
          <p class="small muted">{{ auth.session?.name }}</p>
        </div>
        <button class="btn btn-ghost btn-sm" type="button" (click)="carregar()">Atualizar</button>
      </div>

      <p *ngIf="erro" class="err">{{ erro }}</p>
      <p *ngIf="carregando" class="muted small">Carregando...</p>

      <section class="card card-pad pay-box">
        <h2 style="font-weight:800">Pagamento do servico</h2>
        <p class="small muted">
          Quando o profissional aceitar o pedido, o botao de pagamento fica liberado aqui.
        </p>
      </section>

      <div *ngFor="let pedido of pedidos" class="card card-pad pedido">
        <div>
          <p style="font-weight:800">{{ pedido.serviceTitle }}</p>
          <p class="small muted" *ngIf="pedido.message">{{ pedido.message }}</p>
          <div class="badges">
            <span class="badge" [ngClass]="statusClass(pedido.status)">{{ statusLabel(pedido.status) }}</span>
            <span class="badge" [ngClass]="paymentClass(pedido.paymentStatus)">
              {{ paymentLabel(pedido) }}
            </span>
          </div>
        </div>

        <button
          class="btn btn-primary btn-sm"
          type="button"
          [disabled]="pagandoId === pedido.id || pedido.status !== 'CONFIRMED' || pedido.paymentStatus === 'PAID'"
          (click)="pagar(pedido)"
        >
          {{ pedido.paymentStatus === 'PAID' ? 'Pago' : pagandoId === pedido.id ? 'Pagando...' : 'Pagar agora' }}
        </button>
      </div>

      <p *ngIf="!carregando && pedidos.length === 0" class="muted small empty">
        Voce ainda nao solicitou nenhum servico.
      </p>
    </div>
  `,
  styles: [
    `
      .narrow { max-width: 760px; }
      .header { justify-content: space-between; align-items: center; margin-bottom: 16px; }
      .pay-box { margin-bottom: 12px; border-color: var(--brand-300); background: var(--brand-50); }
      .pedido { display: flex; justify-content: space-between; align-items: center; gap: 14px; margin-bottom: 12px; }
      .badges { display: flex; gap: 8px; flex-wrap: wrap; margin-top: 10px; }
      .empty { padding: 18px 0; }
      .err { color: #b3261e; font-size: 0.85rem; margin-bottom: 10px; }
      @media (max-width: 560px) {
        .header, .pedido { flex-direction: column; align-items: stretch; }
      }
    `,
  ],
})
export class MeusPedidosComponent implements OnInit {
  pedidos: ServiceRequestDto[] = [];
  carregando = true;
  pagandoId: number | null = null;
  erro = '';

  constructor(private api: CallWorkApi, public auth: AuthService) {}

  ngOnInit(): void {
    this.carregar();
  }

  carregar(): void {
    const customerId = this.auth.customerId;
    if (!customerId) {
      this.erro = 'Entre como cliente para ver seus pedidos.';
      this.carregando = false;
      return;
    }

    this.carregando = true;
    this.erro = '';
    this.api.listCustomerRequests(customerId).subscribe({
      next: (pedidos) => {
        this.pedidos = pedidos;
        this.carregando = false;
      },
      error: () => {
        this.erro = 'Nao foi possivel carregar seus pedidos.';
        this.carregando = false;
      },
    });
  }

  pagar(pedido: ServiceRequestDto): void {
    const customerId = this.auth.customerId;
    if (!customerId) return;

    this.pagandoId = pedido.id;
    this.erro = '';
    this.api.payRequest(customerId, pedido.id, 'PIX').subscribe({
      next: (updated) => {
        Object.assign(pedido, updated);
        this.pagandoId = null;
      },
      error: () => {
        this.erro = 'Pagamento liberado somente depois que o profissional aceitar o pedido.';
        this.pagandoId = null;
      },
    });
  }

  statusLabel(status: ServiceRequestDto['status']): string {
    return status === 'PENDING' ? 'Aguardando aceite' : status === 'CONFIRMED' ? 'Aceito' : 'Recusado';
  }

  statusClass(status: ServiceRequestDto['status']): string {
    return status === 'PENDING' ? 'badge-warn' : status === 'CONFIRMED' ? 'badge-ok' : 'badge-muted';
  }

  paymentLabel(pedido: ServiceRequestDto): string {
    return pedido.paymentStatus === 'PAID'
      ? `Pago${pedido.paymentMethod ? ` via ${pedido.paymentMethod}` : ''}`
      : 'Aguardando pagamento';
  }

  paymentClass(status: ServiceRequestDto['paymentStatus']): string {
    return status === 'PAID' ? 'badge-ok' : 'badge-warn';
  }
}
