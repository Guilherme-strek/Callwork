import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    loadComponent: () => import('./pages/home/home.component').then((m) => m.HomeComponent),
  },
  {
    path: 'buscar',
    loadComponent: () => import('./pages/buscar/buscar.component').then((m) => m.BuscarComponent),
  },
  {
    path: 'perfil/:id',
    loadComponent: () => import('./pages/perfil/perfil.component').then((m) => m.PerfilComponent),
  },
  {
    path: 'painel',
    loadComponent: () => import('./pages/painel/painel.component').then((m) => m.PainelComponent),
  },
  {
    path: 'cadastro',
    loadComponent: () =>
      import('./pages/cadastro/cadastro.component').then((m) => m.CadastroComponent),
  },
  { path: '**', redirectTo: '' },
];
