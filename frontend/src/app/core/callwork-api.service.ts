import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import {
  ProfessionalSummary,
  ProfessionalDetail,
  CreateProfessional,
  ServiceRequestDto,
} from './models';

@Injectable({ providedIn: 'root' })
export class CallWorkApi {
  private readonly base = environment.apiUrl;

  constructor(private http: HttpClient) {}

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

  requestService(
    professionalId: number,
    body: { requesterName: string; serviceTitle: string; message: string }
  ): Observable<ServiceRequestDto> {
    return this.http.post<ServiceRequestDto>(
      `${this.base}/professionals/${professionalId}/requests`,
      body
    );
  }

  listRequests(professionalId: number): Observable<ServiceRequestDto[]> {
    return this.http.get<ServiceRequestDto[]>(
      `${this.base}/professionals/${professionalId}/requests`
    );
  }

  updateRequestStatus(
    requestId: number,
    value: 'CONFIRMED' | 'DECLINED'
  ): Observable<ServiceRequestDto> {
    return this.http.patch<ServiceRequestDto>(
      `${this.base}/requests/${requestId}/status?value=${value}`,
      {}
    );
  }
}
