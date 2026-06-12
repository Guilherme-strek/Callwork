import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { map, switchMap } from 'rxjs';
import { AuthService } from '../../core/auth.service';
import { CallWorkApi } from '../../core/callwork-api.service';

type AccountType = 'CUSTOMER' | 'PROFESSIONAL';

@Component({
  selector: 'app-cadastro',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  template: `
    <div class="container narrow" style="padding:32px 20px">
      <div class="mode-tabs" role="tablist" aria-label="Tipo de conta">
        <button
          type="button"
          [class.on]="tipo === 'CUSTOMER'"
          (click)="selecionarTipo('CUSTOMER')"
        >
          Cliente
        </button>
        <button
          type="button"
          [class.on]="tipo === 'PROFESSIONAL'"
          (click)="selecionarTipo('PROFESSIONAL')"
        >
          Profissional
        </button>
      </div>

      <form class="card card-pad" [formGroup]="form" (ngSubmit)="enviar()">
        <h1 style="font-size:1.15rem;font-weight:800">
          {{ tipo === 'CUSTOMER' ? 'Criar conta de cliente' : 'Criar conta profissional' }}
        </h1>
        <p class="small muted" style="margin-bottom:18px">
          {{
            tipo === 'CUSTOMER'
              ? 'Use esta conta para solicitar, acompanhar e pagar servicos.'
              : 'Cadastre seu perfil e seu primeiro servico para aparecer na busca.'
          }}
        </p>

        <div class="field">
          <label for="name">Nome completo</label>
          <input id="name" class="input" formControlName="name" />
          <p class="err" *ngIf="invalido('name')">Informe seu nome.</p>
        </div>

        <div class="row two">
          <div class="field" style="flex:1">
            <label for="email">Email</label>
            <input id="email" class="input" type="email" formControlName="email" />
            <p class="err" *ngIf="invalido('email')">Informe um email valido.</p>
          </div>
          <div class="field" style="flex:1">
            <label for="password">Senha</label>
            <input id="password" class="input" type="password" formControlName="password" />
            <p class="err" *ngIf="invalido('password')">Use pelo menos 6 caracteres.</p>
          </div>
        </div>

        <ng-container *ngIf="tipo === 'PROFESSIONAL'">
          <div class="row two">
            <div class="field" style="flex:1">
              <label for="category">Categoria</label>
              <select id="category" formControlName="category">
                <option *ngFor="let c of categorias" [value]="c">{{ c }}</option>
              </select>
            </div>
            <div class="field" style="flex:1">
              <label for="role">Funcao</label>
              <input id="role" class="input" formControlName="role" placeholder="Ex.: Diarista" />
              <p class="err" *ngIf="invalido('role')">Informe sua funcao.</p>
            </div>
          </div>

          <div class="field">
            <label for="city">Cidade de atuacao</label>
            <input id="city" class="input" formControlName="city" placeholder="Maringa, PR" />
            <p class="err" *ngIf="invalido('city')">Informe sua cidade.</p>
          </div>

          <div class="field">
            <label for="cnpj">CNPJ / MEI (opcional)</label>
            <input
              id="cnpj"
              class="input"
              formControlName="cnpj"
              placeholder="00.000.000/0000-00"
              [style.borderColor]="cnpjValido() ? 'var(--brand-300)' : ''"
              [style.background]="cnpjValido() ? 'var(--brand-50)' : ''"
            />
            <p class="small muted" style="margin-top:6px">
              {{ cnpjValido() ? 'MEI informado.' : 'Deixe em branco se for autonomo.' }}
            </p>
            <p class="err" *ngIf="form.get('cnpj')?.errors?.['pattern']">
              Use o formato 00.000.000/0000-00.
            </p>
          </div>

          <div class="field">
            <label for="about">Sobre voce</label>
            <textarea id="about" class="textarea" rows="3" formControlName="about"></textarea>
          </div>

          <div class="row two">
            <div class="field" style="flex:1">
              <label for="serviceTitle">Primeiro servico</label>
              <input
                id="serviceTitle"
                class="input"
                formControlName="serviceTitle"
                placeholder="Ex.: Limpeza residencial"
              />
              <p class="err" *ngIf="invalido('serviceTitle')">Informe um servico.</p>
            </div>
            <div class="field" style="flex:1">
              <label for="servicePrice">Preco inicial (R$)</label>
              <input
                id="servicePrice"
                class="input"
                type="number"
                min="1"
                step="0.01"
                formControlName="servicePrice"
                placeholder="120,00"
              />
              <p class="err" *ngIf="invalido('servicePrice')">Informe um preco valido.</p>
            </div>
          </div>
        </ng-container>

        <div class="row actions">
          <span class="small muted">
            {{ tipo === 'CUSTOMER' ? 'Cliente solicita e paga servicos' : 'Profissional recebe pedidos' }}
          </span>
          <button type="submit" class="btn btn-primary" [disabled]="enviando">
            {{ enviando ? 'Enviando...' : 'Concluir cadastro' }}
          </button>
        </div>

        <p *ngIf="erro" class="err" style="margin-top:10px">{{ erro }}</p>
      </form>
    </div>
  `,
  styles: [
    `
      .narrow { max-width: 640px; }
      .mode-tabs { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-bottom: 14px; }
      .mode-tabs button { border: 1px solid var(--line); background: #fff; border-radius: 8px; padding: 10px 12px; font-weight: 700; color: var(--ink-soft); }
      .mode-tabs button.on { border-color: var(--brand-500); background: var(--brand-50); color: var(--brand-700); }
      .two { gap: 12px; }
      .actions { justify-content: space-between; align-items: center; margin-top: 8px; }
      .err { color: #b3261e; font-size: 0.75rem; margin-top: 4px; }
      @media (max-width: 520px) {
        .two, .actions { flex-direction: column; align-items: stretch; }
      }
    `,
  ],
})
export class CadastroComponent {
  tipo: AccountType = 'CUSTOMER';
  enviando = false;
  erro = '';
  categorias = ['Limpeza', 'Reformas', 'Tecnologia', 'Beleza'];
  form: FormGroup;

  constructor(
    private fb: FormBuilder,
    private api: CallWorkApi,
    private auth: AuthService,
    private route: ActivatedRoute,
    private router: Router
  ) {
    this.form = this.fb.group({
      name: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required, Validators.minLength(6)]],
      role: [''],
      category: ['Limpeza'],
      city: ['Maringa, PR'],
      cnpj: ['', Validators.pattern(/^$|\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}$/)],
      about: [''],
      serviceTitle: [''],
      servicePrice: [null],
    });

    if (this.route.snapshot.queryParamMap.get('tipo') === 'profissional') {
      this.tipo = 'PROFESSIONAL';
    }
    this.aplicarValidadores();
  }

  selecionarTipo(tipo: AccountType): void {
    this.tipo = tipo;
    this.erro = '';
    this.aplicarValidadores();
  }

  invalido(campo: string): boolean {
    const c = this.form.get(campo);
    return !!c && c.invalid && (c.dirty || c.touched);
  }

  cnpjValido(): boolean {
    const v = (this.form.get('cnpj')?.value ?? '').replace(/\D/g, '');
    return v.length === 14;
  }

  enviar(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    this.enviando = true;
    this.erro = '';
    const raw = this.form.getRawValue();

    if (this.tipo === 'CUSTOMER') {
      this.api
        .createCustomer({ name: raw.name, email: raw.email, password: raw.password })
        .subscribe({
          next: (response) => {
            const customer = response.customer;
            if (!customer) {
              this.erro = 'Conta criada, mas nao foi possivel iniciar a sessao.';
              this.enviando = false;
              return;
            }
            this.auth.saveSession({
              role: 'CUSTOMER',
              name: customer.name,
              email: customer.email,
              customerId: customer.id,
            });
            this.router.navigateByUrl(this.returnUrl('/buscar'));
          },
          error: () => {
            this.erro = 'Nao foi possivel criar a conta. Verifique o email e tente novamente.';
            this.enviando = false;
          },
        });
      return;
    }

    this.api.create({
      name: raw.name,
      email: raw.email,
      password: raw.password,
      role: raw.role,
      category: raw.category,
      city: raw.city,
      about: raw.about,
      cnpj: raw.cnpj,
    }).pipe(
      switchMap((criado) => {
        this.auth.saveSession({
          role: 'PROFESSIONAL',
          name: criado.name,
          email: raw.email,
          professionalId: criado.id,
        });
        return this.api.createService(criado.id, {
          title: raw.serviceTitle,
          priceCents: Math.round(Number(raw.servicePrice) * 100),
          active: true,
        }).pipe(map(() => criado));
      })
    ).subscribe({
      next: (criado) => {
        this.router.navigate(['/perfil', criado.id]);
      },
      error: () => {
        this.erro = 'Nao foi possivel concluir o cadastro. Tente novamente.';
        this.enviando = false;
      },
    });
  }

  private aplicarValidadores(): void {
    const professionalRequired = this.tipo === 'PROFESSIONAL' ? [Validators.required] : [];
    this.form.get('role')?.setValidators(professionalRequired);
    this.form.get('category')?.setValidators(professionalRequired);
    this.form.get('city')?.setValidators(professionalRequired);
    this.form.get('serviceTitle')?.setValidators(professionalRequired);
    this.form.get('servicePrice')?.setValidators(
      this.tipo === 'PROFESSIONAL' ? [Validators.required, Validators.min(1)] : []
    );

    ['role', 'category', 'city', 'serviceTitle', 'servicePrice'].forEach((field) => {
      this.form.get(field)?.updateValueAndValidity();
    });
  }

  private returnUrl(fallback: string): string {
    return this.route.snapshot.queryParamMap.get('returnUrl') || fallback;
  }
}
