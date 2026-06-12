import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { AuthService } from './auth.service';
import {
  ProfessionalSummary,
  ProfessionalDetail,
  CreateProfessional,
  CreateCustomer,
  LoginResponse,
  ServiceItem,
  ServiceRequestDto,
  UpsertService,
} from './models';

@Injectable({ providedIn: 'root' })
export class CallWorkApi {
  private readonly base = environment.apiUrl;

  constructor(private http: HttpClient, private auth: AuthService) {}

  search(q: string, category: string, meiOnly: boolean): Observable<ProfessionalSummary[]> {
    let params = new HttpParams().set('meiOnly', meiOnly);
    if (q) params = params.set('q', q);
    if (category && category !== 'Todos') params = params.set('category', category);
    return this.http.get<ProfessionalSummary[]>(`${this.base}/professionals`, { params });
  }

  getById(id: number): Observable<ProfessionalDetail> {
    return this.http.get<ProfessionalDetail>(`${this.base}/professionals/${id}`);
  }

  create(payload: CreateProfessional): Observable<ProfessionalDetail> {
    return this.http.post<ProfessionalDetail>(`${this.base}/professionals`, payload);
  }

  createCustomer(payload: CreateCustomer): Observable<LoginResponse> {
    return this.http.post<LoginResponse>(`${this.base}/customers`, payload);
  }

  createService(professionalId: number, payload: UpsertService): Observable<ServiceItem> {
    return this.http.post<ServiceItem>(
      `${this.base}/professionals/${professionalId}/services`,
      payload,
      { headers: this.authHeaders() }
    );
  }

  updateService(
    professionalId: number,
    serviceId: number,
    payload: UpsertService
  ): Observable<ServiceItem> {
    return this.http.put<ServiceItem>(
      `${this.base}/professionals/${professionalId}/services/${serviceId}`,
      payload,
      { headers: this.authHeaders() }
    );
  }

  deleteService(professionalId: number, serviceId: number): Observable<void> {
    return this.http.delete<void>(
      `${this.base}/professionals/${professionalId}/services/${serviceId}`,
      { headers: this.authHeaders() }
    );
  }

  requestService(
    professionalId: number,
    body: { requesterName: string; serviceTitle: string; message: string }
  ): Observable<ServiceRequestDto> {
    return this.http.post<ServiceRequestDto>(
      `${this.base}/professionals/${professionalId}/requests`,
      body,
      { headers: this.customerHeaders() }
    );
  }

  listCustomerRequests(customerId: number): Observable<ServiceRequestDto[]> {
    return this.http.get<ServiceRequestDto[]>(`${this.base}/customers/${customerId}/requests`, {
      headers: this.customerHeaders(),
    });
  }

  payRequest(customerId: number, requestId: number, method: string): Observable<ServiceRequestDto> {
    return this.http.patch<ServiceRequestDto>(
      `${this.base}/customers/${customerId}/requests/${requestId}/payment?method=${method}`,
      {},
      { headers: this.customerHeaders() }
    );
  }

  listRequests(professionalId: number): Observable<ServiceRequestDto[]> {
    return this.http.get<ServiceRequestDto[]>(
      `${this.base}/professionals/${professionalId}/requests`,
      { headers: this.authHeaders() }
    );
  }

  listServices(professionalId: number): Observable<ServiceItem[]> {
    return this.http.get<ServiceItem[]>(`${this.base}/professionals/${professionalId}/services`, {
      headers: this.authHeaders(),
    });
  }

  updateRequestStatus(
    requestId: number,
    value: 'CONFIRMED' | 'DECLINED'
  ): Observable<ServiceRequestDto> {
    return this.http.patch<ServiceRequestDto>(
      `${this.base}/requests/${requestId}/status?value=${value}`,
      {},
      { headers: this.authHeaders() }
    );
  }

  private authHeaders(): HttpHeaders {
    const professionalId = this.auth.professionalId;
    return professionalId
      ? new HttpHeaders({ 'X-Professional-Id': String(professionalId) })
      : new HttpHeaders();
  }

  private customerHeaders(): HttpHeaders {
    const customerId = this.auth.customerId;
    return customerId
      ? new HttpHeaders({ 'X-Customer-Id': String(customerId) })
      : new HttpHeaders();
  }
}
