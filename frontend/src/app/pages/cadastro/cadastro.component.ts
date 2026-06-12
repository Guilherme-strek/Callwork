import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import {
  FormBuilder,
  FormGroup,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { CallWorkApi } from '../../core/callwork-api.service';

@Component({
  selector: "app-cadastro",
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  template: `
    <div class="container narrow" style="padding:32px 20px">
      <!-- stepper -->
      <ol class="stepper">
        <li
          *ngFor="let s of etapas; let i = index"
          [class.done]="i + 1 < passo"
          [class.cur]="i + 1 === passo"
        >
          <span class="dot">{{ i + 1 < passo ? "✓" : i + 1 }}</span>
          <span class="lbl">{{ s }}</span>
        </li>
      </ol>

      <form class="card card-pad" [formGroup]="form" (ngSubmit)="enviar()">
        <h1 style="font-size:1.15rem;font-weight:800">Dados profissionais</h1>
        <p class="small muted" style="margin-bottom:18px">
          Esses dados aparecem no seu perfil público.
        </p>

        <div class="field">
          <label for="name">Nome completo</label>
          <input id="name" class="input" formControlName="name" />
          <p class="err" *ngIf="invalido('name')">Informe seu nome.</p>
        </div>

        <div class="row two">
          <div class="field" style="flex:1">
            <label for="category">Categoria</label>
            <select id="category" formControlName="category">
              <option *ngFor="let c of categorias" [value]="c">{{ c }}</option>
            </select>
          </div>
          <div class="field" style="flex:1">
            <label for="role">Função</label>
            <input
              id="role"
              class="input"
              formControlName="role"
              placeholder="Ex.: Diarista"
            />
            <p class="err" *ngIf="invalido('role')">Informe sua função.</p>
          </div>
        </div>

        <div class="field" style="flex:1">
          <label for="city">Cidade de atuação</label>
          <input id="city" class="input" formControlName="city" />
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
          <p
            class="small"
            [style.color]="
              cnpjValido() ? 'var(--brand-700)' : 'var(--ink-mute)'
            "
            style="margin-top:6px"
          >
            {{
              cnpjValido()
                ? "✔ MEI ativo confirmado na Receita Federal"
                : "Preencha para validar seu MEI (ou deixe em branco se for autônomo)."
            }}
          </p>
          <p class="err" *ngIf="form.get('cnpj')?.errors?.['pattern']">
            Formato inválido. Use 00.000.000/0000-00.
          </p>
        </div>

        <div class="field">
          <label for="about">Sobre você</label>
          <textarea
            id="about"
            class="textarea"
            rows="3"
            formControlName="about"
          ></textarea>
        </div>

        <div
          class="row"
          style="justify-content:space-between;align-items:center;margin-top:8px"
        >
          <span class="small muted"
            >‹ Etapa {{ passo }} de {{ etapas.length }}</span
          >
          <button type="submit" class="btn btn-primary" [disabled]="enviando">
            {{ enviando ? "Enviando…" : "Concluir cadastro" }}
          </button>
        </div>

        <p *ngIf="erro" class="err" style="margin-top:10px">{{ erro }}</p>
      </form>
    </div>
  `,
  styles: [
    `
      .narrow {
        max-width: 600px;
      }
      .stepper {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 20px;
        list-style: none;
      }
      .stepper li {
        display: flex;
        align-items: center;
        gap: 6px;
        flex: 1;
      }
      .stepper li:last-child {
        flex: none;
      }
      .dot {
        width: 24px;
        height: 24px;
        border-radius: 50%;
        display: grid;
        place-items: center;
        font-size: 0.72rem;
        font-weight: 600;
        background: #e2e0d7;
        color: var(--ink-soft);
      }
      .stepper li.cur .dot,
      .stepper li.done .dot {
        background: var(--brand-500);
        color: #fff;
      }
      .lbl {
        font-size: 0.75rem;
        color: var(--ink-mute);
      }
      .stepper li.cur .lbl {
        color: var(--ink);
        font-weight: 600;
      }
      .two {
        gap: 12px;
      }
      .err {
        color: #b3261e;
        font-size: 0.75rem;
        margin-top: 4px;
      }
      @media (max-width: 520px) {
        .lbl {
          display: none;
        }
        .two {
          flex-direction: column;
        }
      }
    `,
  ],
})
export class CadastroComponent {
  passo = 2;
  enviando = false;
  erro = "";
  etapas = ["Conta", "Dados profissionais", "Serviços"];
  categorias = ["Limpeza", "Reformas", "Tecnologia", "Beleza"];
  form: FormGroup;

  constructor(
    private fb: FormBuilder,
    private api: CallWorkApi,
    private router: Router,
  ) {
    this.form = this.fb.group({
      name: ["Ana Moura", Validators.required],
      role: ["Diarista", Validators.required],
      category: ["Limpeza", Validators.required],
      city: ["Maringá, PR", Validators.required],
      cnpj: [
        "12.345.678/0001-90",
        Validators.pattern(/^$|\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}/),
      ],
      about: [
        "Diarista com 6 anos de experiência em limpeza residencial e comercial.",
      ],
    });
  }

  invalido(campo: string): boolean {
    const c = this.form.get(campo);
    return !!c && c.invalid && (c.dirty || c.touched);
  }

  cnpjValido(): boolean {
    const v = (this.form.get("cnpj")?.value ?? "").replace(/\D/g, "");
    return v.length === 14;
  }

  enviar(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    this.enviando = true;
    this.erro = "";
    this.api.create(this.form.getRawValue()).subscribe({
      next: (criado) => this.router.navigate(["/perfil", criado.id]),
      error: () => {
        this.erro = "Não foi possível concluir o cadastro. Tente novamente.";
        this.enviando = false;
      },
    });
  }
}
