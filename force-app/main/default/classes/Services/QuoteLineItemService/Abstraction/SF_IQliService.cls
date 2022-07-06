public interface SF_IQliService {
    SF_QliWrapper getQLIs(Id quoteId);
    void updateQuantity(Id qliId,Double quantity);
}