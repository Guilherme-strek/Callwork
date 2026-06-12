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
  role: string;
  category: string;
  city: string;
  about: string;
  cnpj: string;
}

export interface ServiceRequestDto {
  id: number;
  professionalId: number;
  requesterName: string;
  serviceTitle: string;
  message: string;
  status: 'PENDING' | 'CONFIRMED' | 'DECLINED';
  createdAt: string;
}
