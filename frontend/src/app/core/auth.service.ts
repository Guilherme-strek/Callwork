import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { BehaviorSubject, map, tap } from 'rxjs';
import { environment } from '../../environments/environment';
import { LoginResponse } from './models';

export interface AppSession {
  role: 'PROFESSIONAL' | 'CUSTOMER';
  name: string;
  email: string;
  professionalId?: number;
  customerId?: number;
}

const STORAGE_KEY = 'callwork_session';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private readonly sessionSubject = new BehaviorSubject<AppSession | null>(this.readSession());
  readonly session$ = this.sessionSubject.asObservable();

  constructor(private http: HttpClient) {}

  get session(): AppSession | null {
    return this.sessionSubject.value;
  }

  get isLoggedIn(): boolean {
    return !!this.session;
  }

  get professionalId(): number | null {
    return this.session?.professionalId ?? null;
  }

  get customerId(): number | null {
    return this.session?.customerId ?? null;
  }

  loginWithCredentials(email: string, password: string) {
    return this.http.post<LoginResponse>(`${environment.apiUrl}/auth/login`, { email, password }).pipe(
      map((response) => ({
        role: response.role,
        name: response.professional?.name ?? response.customer?.name ?? '',
        email: response.professional?.email ?? response.customer?.email ?? '',
        professionalId: response.professional?.id,
        customerId: response.customer?.id,
      })),
      tap((session) => this.saveSession(session))
    );
  }

  saveSession(session: AppSession): void {
    const normalized: AppSession = {
      name: session.name.trim(),
      email: session.email.trim().toLowerCase(),
      professionalId: session.professionalId,
      customerId: session.customerId,
      role: session.role,
    };
    localStorage.setItem(STORAGE_KEY, JSON.stringify(normalized));
    this.sessionSubject.next(normalized);
  }

  logout(): void {
    localStorage.removeItem(STORAGE_KEY);
    this.sessionSubject.next(null);
  }

  private readSession(): AppSession | null {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return null;

    try {
      const parsed = JSON.parse(raw) as AppSession;
      if (!parsed.name?.trim() || !parsed.email?.trim() || !parsed.role) return null;
      return parsed;
    } catch {
      localStorage.removeItem(STORAGE_KEY);
      return null;
    }
  }
}
