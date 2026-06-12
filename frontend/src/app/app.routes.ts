import { Routes } from '@angular/router';
import { requireCustomerSession, requireProfessionalSession } from './core/auth.guard';

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
    canActivate: [requireProfessionalSession],
    loadComponent: () => import('./pages/painel/painel.component').then((m) => m.PainelComponent),
  },
  {
    path: 'meus-pedidos',
    canActivate: [requireCustomerSession],
    loadComponent: () =>
      import('./pages/meus-pedidos/meus-pedidos.component').then((m) => m.MeusPedidosComponent),
  },
  {
    path: 'login',
    loadComponent: () => import('./pages/login/login.component').then((m) => m.LoginComponent),
  },
  {
    path: 'cadastro',
    loadComponent: () =>
      import('./pages/cadastro/cadastro.component').then((m) => m.CadastroComponent),
  },
  { path: '**', redirectTo: '' },
];
