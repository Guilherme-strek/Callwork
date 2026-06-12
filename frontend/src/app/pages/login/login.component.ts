import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { AuthService } from '../../core/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  template: `
    <div class="container narrow" style="padding:32px 20px">
      <form class="card card-pad" (ngSubmit)="entrar()">
        <h1 style="font-size:1.2rem;font-weight:800">Entrar</h1>
        <p class="small muted" style="margin:6px 0 18px">
          Acesse com email e senha para solicitar servicos ou abrir seu painel.
        </p>

        <div class="field">
          <label for="email">Email</label>
          <input id="email" class="input" name="email" type="email" [(ngModel)]="email" />
          <p class="err" *ngIf="tentou && !email.trim()">Informe seu email.</p>
        </div>

        <div class="field">
          <label for="password">Senha</label>
          <input id="password" class="input" name="password" type="password" [(ngModel)]="password" />
          <p class="err" *ngIf="tentou && !password.trim()">Informe sua senha.</p>
        </div>

        <p class="err" *ngIf="erro">{{ erro }}</p>

        <div class="row actions">
          <a routerLink="/cadastro" class="small" style="color:var(--brand-600)">Criar conta</a>
          <button type="submit" class="btn btn-primary" [disabled]="enviando">
            {{ enviando ? 'Entrando...' : 'Entrar' }}
          </button>
        </div>

        <p class="small muted" style="margin-top:12px">
          Demo profissional: ana&#64;callwork.local / password
        </p>
      </form>
    </div>
  `,
  styles: [
    `
      .narrow { max-width: 520px; }
      .actions { justify-content: space-between; align-items: center; margin-top: 12px; }
      .err { color: #b3261e; font-size: 0.75rem; margin-top: 4px; }
      @media (max-width: 520px) {
        .actions { flex-direction: column; align-items: stretch; }
      }
    `,
  ],
})
export class LoginComponent {
  email = '';
  password = '';
  tentou = false;
  enviando = false;
  erro = '';

  constructor(
    private auth: AuthService,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  entrar(): void {
    this.tentou = true;
    this.erro = '';

    if (!this.email.trim() || !this.password.trim()) return;

    this.enviando = true;
    this.auth.loginWithCredentials(this.email, this.password).subscribe({
      next: () => this.router.navigateByUrl(this.returnUrl()),
      error: () => {
        this.erro = 'Email ou senha inválidos.';
        this.enviando = false;
      },
    });
  }

  private returnUrl(): string {
    const requested = this.route.snapshot.queryParamMap.get('returnUrl');
    if (requested) return requested;
    return this.auth.session?.role === 'CUSTOMER' ? '/meus-pedidos' : '/painel';
  }
}
