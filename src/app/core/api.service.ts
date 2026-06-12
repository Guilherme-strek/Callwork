import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { ProfessionalSummary, ProfessionalDetail, CreateProfessional, ServiceRequestDto } from './models';

const BASE = 'http://localhost:8080/api';

@Injectable({ providedIn: 'root' })
export class ApiService {
  constructor(private http: HttpClient) {}

  search(q: string, category: string, meiOnly: boolean): Observable<ProfessionalSummary[]> {
    return this.http.get<ProfessionalSummary[]>(`${BASE}/professionals`, {
      params: { q, category, meiOnly: String(meiOnly) }
    });
  }

  getById(id: number): Observable<ProfessionalDetail> {
    return this.http.get<ProfessionalDetail>(`${BASE}/professionals/${id}`);
  }

  create(data: CreateProfessional): Observable<ProfessionalDetail> {
    return this.http.post<ProfessionalDetail>(`${BASE}/professionals`, data);
  }

  requestService(professionalId: number, payload: { requesterName: string; serviceTitle: string; message: string }): Observable<ServiceRequestDto> {
    return this.http.post<ServiceRequestDto>(`${BASE}/professionals/${professionalId}/requests`, payload);
  }

  listRequests(professionalId: number): Observable<ServiceRequestDto[]> {
    return this.http.get<ServiceRequestDto[]>(`${BASE}/professionals/${professionalId}/requests`);
  }

  updateRequestStatus(requestId: number, status: string): Observable<ServiceRequestDto> {
    return this.http.patch<ServiceRequestDto>(`${BASE}/requests/${requestId}/status`, null, {
      params: { value: status }
    });
  }
}
