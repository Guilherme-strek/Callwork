export interface ProfessionalSummary {
  id: number;
  name: string;
  role: string;
  category: string;
  city: string;
  meiVerified: boolean;
  rating: number;
  reviewsCount: number;
  startingPrice: string | null;
}

export interface ServiceItem {
  id: number;
  title: string;
  price: string;
  priceCents: number;
  active: boolean;
}

export interface Review {
  id: number;
  author: string;
  rating: number;
  comment: string;
  createdAt: string;
}

export interface ProfessionalDetail {
  id: number;
  name: string;
  role: string;
  category: string;
  city: string;
  about: string;
  meiVerified: boolean;
  rating: number;
  reviewsCount: number;
  services: ServiceItem[];
  reviews: Review[];
}

export interface CreateProfessional {
  name: string;
  email: string;
  password: string;
  role: string;
  category: string;
  city: string;
  about: string;
  cnpj: string;
}

export interface LoginResponse {
  message: string;
  role: 'PROFESSIONAL' | 'CUSTOMER';
  professional: {
    id: number;
    name: string;
    email: string;
  } | null;
  customer: {
    id: number;
    name: string;
    email: string;
  } | null;
}

export interface CreateCustomer {
  name: string;
  email: string;
  password: string;
}

export interface UpsertService {
  title: string;
  priceCents: number;
  active: boolean;
}

export interface ServiceRequestDto {
  id: number;
  professionalId: number;
  requesterCustomerId: number | null;
  requesterName: string;
  serviceTitle: string;
  message: string;
  status: 'PENDING' | 'CONFIRMED' | 'DECLINED';
  paymentStatus: 'WAITING_PAYMENT' | 'PAID';
  paymentMethod: string | null;
  createdAt: string;
}
