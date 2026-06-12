import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { AuthService } from './core/auth.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterOutlet, RouterLink, RouterLinkActive],
  template: `
    <header class="nav">
      <div class="container nav-inner">
        <a routerLink="/" class="logo">
          <span class="logo-mark">☎</span> Call Work
        </a>
        <nav class="links">
          <a routerLink="/" routerLinkActive="on" [routerLinkActiveOptions]="{ exact: true }">Início</a>
          <a routerLink="/buscar" routerLinkActive="on">Buscar</a>
          <a *ngIf="auth.session?.role === 'PROFESSIONAL'" routerLink="/painel" routerLinkActive="on">Painel</a>
          <a *ngIf="auth.session?.role === 'CUSTOMER'" routerLink="/meus-pedidos" routerLinkActive="on">Meus pedidos</a>
        </nav>
        <div class="session" *ngIf="auth.session$ | async as session; else guest">
          <a
            *ngIf="session.role === 'PROFESSIONAL' && session.professionalId; else customerName"
            class="small session-name"
            [routerLink]="['/perfil', session.professionalId]"
          >
            {{ session.name }}
          </a>
          <ng-template #customerName>
            <span class="small muted">{{ session.name }}</span>
          </ng-template>
          <button class="btn btn-ghost btn-sm" type="button" (click)="logout()">Sair</button>
        </div>
        <ng-template #guest>
          <div class="session">
            <a routerLink="/login" class="btn btn-ghost btn-sm">Entrar</a>
            <a routerLink="/cadastro" class="btn btn-primary btn-sm">Criar conta</a>
          </div>
        </ng-template>
      </div>
    </header>

    <main>
      <router-outlet></router-outlet>
    </main>

    <footer class="footer">
      <div class="container foot-inner">
        <span>© 2026 Call Work · Marketplace de serviços locais</span>
        <span class="muted">Valorizando autônomos, MEIs e freelancers</span>
      </div>
    </footer>
  `,
  styles: [
    `
      .nav {
        position: sticky; top: 0; z-index: 30;
        background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(8px);
        border-bottom: 1px solid var(--line);
      }
      .nav-inner { height: 56px; display: flex; align-items: center; justify-content: space-between; gap: 16px; }
      .logo { display: flex; align-items: center; gap: 8px; font-weight: 800; }
      .logo-mark { width: 30px; height: 30px; border-radius: 8px; background: var(--brand-500); color: #fff; display: grid; place-items: center; }
      .links { display: flex; gap: 24px; font-size: 0.9rem; color: var(--ink-soft); }
      .links a.on { color: var(--brand-600); font-weight: 600; }
      .session { display: flex; align-items: center; gap: 8px; }
      .session-name { color: var(--ink-soft); font-weight: 600; }
      .session-name:hover { color: var(--brand-600); text-decoration: underline; }
      .footer { border-top: 1px solid var(--line); background: #fff; margin-top: 40px; }
      .foot-inner { padding: 22px 20px; display: flex; justify-content: space-between; font-size: 0.78rem; color: var(--ink-soft); }
      @media (max-width: 640px) {
        .links { display: none; }
        .foot-inner { flex-direction: column; gap: 4px; }
      }
    `,
  ],
})
export class AppComponent {
  constructor(public auth: AuthService, private router: Router) {}

  logout(): void {
    this.auth.logout();
    this.router.navigate(['/login']);
  }
}
