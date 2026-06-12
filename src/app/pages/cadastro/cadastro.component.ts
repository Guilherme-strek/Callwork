import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { ApiService } from '../../core/api.service';

@Component({
  selector: 'app-cadastro',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  template: `
    <header class="top-nav">
      <div class="logo">
        <span class="logo-mark">☎</span> Call Work
      </div>
    </header>

    <div class="page" style="padding-top:20px">

      <div class="stepper">
        <div class="step-bar done"></div>
        <div class="step-bar cur"></div>
        <div class="step-bar"></div>
      </div>

      <p style="font-size:1.1rem;font-weight:800;margin-bottom:4px">Dados profissionais</p>
      <p class="small muted" style="margin-bottom:20px">Esses dados aparecem no seu perfil público.</p>

      <form [formGroup]="form" (ngSubmit)="enviar()">

        <div class="field">
          <label for="name">Nome completo</label>
          <input id="name" class="input" formControlName="name" placeholder="Seu nome completo" />
          <p *ngIf="invalido('name')" style="color:#b3261e;font-size:.72rem;margin-top:4px">Informe seu nome.</p>
        </div>

        <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
          <div class="field">
            <label for="category">Categoria</label>
            <select id="category" formControlName="category">
              <option *ngFor="let c of categorias" [value]="c">{{ c }}</option>
            </select>
          </div>
          <div class="field">
            <label for="role">Função</label>
            <input id="role" class="input" formControlName="role" placeholder="Ex.: Diarista" />
            <p *ngIf="invalido('role')" style="color:#b3261e;font-size:.72rem;margin-top:4px">Obrigatório.</p>
          </div>
        </div>

        <div class="field">
          <label for="city">Cidade de atuação</label>
          <input id="city" class="input" formControlName="city" placeholder="Ex.: Maringá, PR" />
          <p *ngIf="invalido('city')" style="color:#b3261e;font-size:.72rem;margin-top:4px">Informe sua cidade.</p>
        </div>

        <div class="field">
          <label for="cnpj">CNPJ / MEI <span class="muted">(opcional)</span></label>
          <input id="cnpj" class="input" formControlName="cnpj" placeholder="00.000.000/0000-00"
            [style.borderColor]="cnpjValido() ? 'var(--brand-500)' : ''"
            [style.background]="cnpjValido() ? 'var(--brand-50)' : ''"
          />
          <p *ngIf="cnpjValido()" style="color:var(--brand-700);font-size:.72rem;margin-top:4px;font-weight:700">
            ✓ MEI válido — você será verificado
          </p>
          <p *ngIf="form.get('cnpj')?.errors?.['pattern']" style="color:#b3261e;font-size:.72rem;margin-top:4px">
            Formato inválido. Use 00.000.000/0000-00.
          </p>
        </div>

        <div class="field">
          <label for="about">Sobre você</label>
          <textarea id="about" formControlName="about" rows="3" placeholder="Fale sobre sua experiência..."></textarea>
        </div>

        <p *ngIf="erro" style="color:#b3261e;font-size:.82rem;margin-bottom:12px;text-align:center">{{ erro }}</p>

        <button type="submit" class="btn btn-primary btn-block" [disabled]="enviando">
          {{ enviando ? 'Cadastrando...' : 'Concluir cadastro' }}
        </button>

        <p class="small muted" style="text-align:center;margin-top:14px">Etapa 2 de 3</p>

      </form>
    </div>
  `,
})
export class CadastroComponent {
  enviando = false;
  erro = '';
  categorias = ['Limpeza', 'Reformas', 'Tecnologia', 'Beleza'];
  form: FormGroup;

  constructor(private fb: FormBuilder, private api: ApiService, private router: Router) {
    this.form = this.fb.group({
      name: ['', Validators.required],
      role: ['', Validators.required],
      category: ['Limpeza', Validators.required],
      city: ['', Validators.required],
      cnpj: ['', Validators.pattern(/^$|\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}/)],
      about: [''],
    });
  }

  invalido(campo: string) {
    const c = this.form.get(campo);
    return !!c && c.invalid && (c.dirty || c.touched);
  }

  cnpjValido() {
    const v = (this.form.get('cnpj')?.value ?? '').replace(/\D/g, '');
    return v.length === 14;
  }

  enviar() {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    this.enviando = true;
    this.erro = '';
    this.api.create(this.form.getRawValue()).subscribe({
      next: criado => this.router.navigate(['/perfil', criado.id]),
      error: () => { this.erro = 'Não foi possível concluir o cadastro. Tente novamente.'; this.enviando = false; }
    });
  }
}
