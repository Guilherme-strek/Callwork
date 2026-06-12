import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { Subject, debounceTime, switchMap, startWith } from 'rxjs';
import { ApiService } from '../../core/api.service';
import { ProfessionalSummary } from '../../core/models';

@Component({
  selector: 'app-buscar',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  template: `
    <header class="top-nav">
      <div class="logo">
        <span class="logo-mark">☎</span> Call Work
      </div>
    </header>

    <div class="page" style="padding-top:16px">

      <div class="search-wrap" style="margin-bottom:12px">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" aria-hidden="true">
          <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
        </svg>
        <input
          type="search" placeholder="Diarista, eletricista..."
          [(ngModel)]="q" (ngModelChange)="trigger.next()"
          aria-label="Buscar profissionais"
        />
        <button *ngIf="q" (click)="limpar()" style="color:var(--ink-mute);font-size:1.1rem;background:none;border:none;cursor:pointer">✕</button>
      </div>

      <div class="chips" style="margin-bottom:14px">
        <button *ngFor="let c of categorias" class="chip" [class.on]="categoria===c" (click)="setCategoria(c)">{{ c }}</button>
      </div>

      <label class="row" style="align-items:center;margin-bottom:16px;gap:8px;cursor:pointer">
        <input type="checkbox" [(ngModel)]="meiOnly" (ngModelChange)="trigger.next()" style="width:18px;height:18px;accent-color:var(--brand-700)" />
        <span class="small" style="color:var(--ink-soft)">Somente MEI verificado</span>
      </label>

      <p class="sec-title">{{ lista.length }} profissionais · Maringá, PR</p>

      <p *ngIf="carregando" class="muted small" style="text-align:center;padding:24px 0">Carregando...</p>

      <div *ngIf="!carregando && lista.length===0" class="empty">
        Nenhum profissional encontrado.<br>Tente outra categoria ou limpe os filtros.
      </div>

      <div class="stack">
        <a *ngFor="let p of lista" [routerLink]="['/perfil', p.id]" class="pro-card">
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
      </div>

    </div>
  `,
})
export class BuscarComponent implements OnInit {
  q = '';
  categoria = 'Todos';
  meiOnly = false;
  lista: ProfessionalSummary[] = [];
  carregando = false;
  categorias = ['Todos', 'Limpeza', 'Reformas', 'Tecnologia', 'Beleza'];
  trigger = new Subject<void>();

  constructor(private api: ApiService) {}

  ngOnInit() {
    this.trigger.pipe(
      startWith(undefined as void),
      debounceTime(260),
      switchMap(() => { this.carregando = true; return this.api.search(this.q, this.categoria, this.meiOnly); })
    ).subscribe(list => { this.lista = list; this.carregando = false; });
  }

  setCategoria(c: string) { this.categoria = c; this.trigger.next(); }
  limpar() { this.q = ''; this.trigger.next(); }
  initials(name: string) { return name.split(' ').map(n => n[0]).slice(0, 2).join('').toUpperCase(); }
}
