import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { Subject, debounceTime, switchMap, startWith } from 'rxjs';
import { CallWorkApi } from '../../core/callwork-api.service';
import { ProfessionalSummary } from '../../core/models';

@Component({
  selector: 'app-buscar',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  template: `
    <div class="container" style="padding:24px 20px">
      <div class="row" style="flex-wrap:wrap">
        <label class="searchbar">
          <span aria-hidden="true">Busca</span>
          <input
            type="text"
            [(ngModel)]="q"
            (ngModelChange)="onChange()"
            placeholder="Diarista, eletricista, designer..."
            aria-label="Buscar profissionais"
          />
        </label>
        <span class="loc">Maringa, PR</span>
      </div>

      <div class="chips">
        <button
          *ngFor="let c of categorias"
          (click)="setCategoria(c)"
          class="chip"
          [class.on]="categoria === c"
        >
          {{ c }}
        </button>
      </div>

      <div class="layout">
        <aside class="filters">
          <h2 style="font-weight:700;font-size:.95rem;margin-bottom:12px">Filtros</h2>
          <label class="check">
            <input type="checkbox" [(ngModel)]="meiOnly" (ngModelChange)="onChange()" />
            Somente MEI verificado
          </label>
        </aside>

        <section>
          <p class="muted small" style="margin-bottom:12px">
            {{ lista.length }} profissionais em Maringa, PR
          </p>

          <p *ngIf="carregando" class="muted">Carregando...</p>
          <p *ngIf="erro" class="err">{{ erro }}</p>

          <div *ngIf="!carregando && !erro && lista.length === 0" class="card card-pad empty">
            Nenhum profissional encontrado. Tente outra categoria ou limpe os filtros.
          </div>

          <div class="results">
            <article *ngFor="let p of lista" class="card card-pad pro">
              <div class="row" style="align-items:center">
                <div class="avatar" style="width:40px;height:40px;background:#e1f5ee;color:#085041">
                  {{ initials(p.name) }}
                </div>
                <div style="flex:1;min-width:0">
                  <a [routerLink]="['/perfil', p.id]" class="profile-link">{{ p.name }}</a>
                  <p class="small muted">{{ p.role }}</p>
                </div>
                <span class="badge" [class.badge-ok]="p.meiVerified" [class.badge-muted]="!p.meiVerified">
                  {{ p.meiVerified ? 'MEI' : 'Autonomo' }}
                </span>
              </div>
              <div class="row" style="justify-content:space-between;margin-top:10px">
                <span class="small muted">{{ p.rating }} - {{ p.reviewsCount }} aval.</span>
                <span style="font-weight:600" *ngIf="p.startingPrice">{{ p.startingPrice }}</span>
              </div>
            </article>
          </div>
        </section>
      </div>
    </div>
  `,
  styles: [
    `
      .searchbar { flex: 1; min-width: 220px; display: flex; align-items: center; gap: 8px; border: 1px solid #dcdcd4; border-radius: 12px; padding: 0 12px; height: 44px; background: #fff; }
      .searchbar span { font-size: 0.78rem; color: var(--ink-soft); }
      .searchbar input { flex: 1; border: 0; outline: none; font: inherit; background: transparent; }
      .loc { display: flex; align-items: center; gap: 6px; border: 1px solid #dcdcd4; border-radius: 12px; padding: 0 14px; height: 44px; font-size: 0.85rem; color: var(--ink-soft); background: #fff; }
      .chips { display: flex; gap: 8px; margin: 14px 0; overflow-x: auto; }
      .chip { flex-shrink: 0; font-size: 0.8rem; padding: 6px 14px; border-radius: 10px; border: 1px solid #dcdcd4; background: #fff; color: var(--ink-soft); }
      .chip.on { background: var(--brand-50); color: var(--brand-700); border-color: var(--brand-100); }
      .layout { display: grid; grid-template-columns: 190px 1fr; gap: 24px; }
      .check { display: flex; align-items: center; gap: 8px; font-size: 0.85rem; color: var(--ink-soft); }
      .results { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
      .pro { transition: 0.15s; }
      .pro:hover { transform: translateY(-2px); }
      .profile-link { display: inline-block; font-weight: 700; color: var(--ink); }
      .profile-link:hover { color: var(--brand-600); text-decoration: underline; }
      .empty { text-align: center; color: var(--ink-soft); border-style: dashed; }
      .err { color: #b3261e; font-size: 0.85rem; margin-bottom: 12px; }
      @media (max-width: 900px) { .layout { grid-template-columns: 1fr; } .results { grid-template-columns: repeat(2, 1fr); } .filters { display: none; } }
      @media (max-width: 560px) { .results { grid-template-columns: 1fr; } }
    `,
  ],
})
export class BuscarComponent implements OnInit {
  q = '';
  categoria = 'Todos';
  meiOnly = false;
  lista: ProfessionalSummary[] = [];
  carregando = false;
  erro = '';
  categorias = ['Todos', 'Limpeza', 'Reformas', 'Tecnologia', 'Beleza'];

  private gatilho = new Subject<void>();

  constructor(private api: CallWorkApi) {}

  ngOnInit(): void {
    this.gatilho
      .pipe(
        startWith(undefined),
        debounceTime(250),
        switchMap(() => {
          this.carregando = true;
          this.erro = '';
          return this.api.search(this.q, this.categoria, this.meiOnly);
        })
      )
      .subscribe({
        next: (list) => {
          this.lista = list;
          this.carregando = false;
        },
        error: () => {
          this.lista = [];
          this.erro = 'Nao foi possivel carregar os profissionais.';
          this.carregando = false;
        },
      });
  }

  onChange(): void {
    this.gatilho.next();
  }

  setCategoria(c: string): void {
    this.categoria = c;
    this.onChange();
  }

  initials(name: string): string {
    return name.split(' ').map((n) => n[0]).slice(0, 2).join('').toUpperCase();
  }
}
