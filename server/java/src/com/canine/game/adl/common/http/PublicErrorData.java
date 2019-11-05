/* @generated from adl module common.http */

package com.canine.game.adl.common.http;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.adl.runtime.Factories;
import org.adl.runtime.Factory;
import org.adl.runtime.JsonBinding;
import org.adl.runtime.JsonBindings;
import org.adl.runtime.Lazy;
import org.adl.runtime.sys.adlast.ScopedName;
import org.adl.runtime.sys.adlast.TypeExpr;
import org.adl.runtime.sys.adlast.TypeRef;
import java.util.ArrayList;
import java.util.Objects;

/**
 * The standard message body for errors
 */
public class PublicErrorData {

  /* Members */

  private String publicMessage;

  /* Constructors */

  public PublicErrorData(String publicMessage) {
    this.publicMessage = Objects.requireNonNull(publicMessage);
  }

  public PublicErrorData() {
    this.publicMessage = "";
  }

  public PublicErrorData(PublicErrorData other) {
    this.publicMessage = other.publicMessage;
  }

  /* Accessors and mutators */

  public String getPublicMessage() {
    return publicMessage;
  }

  public void setPublicMessage(String publicMessage) {
    this.publicMessage = Objects.requireNonNull(publicMessage);
  }

  /* Object level helpers */

  @Override
  public boolean equals(Object other0) {
    if (!(other0 instanceof PublicErrorData)) {
      return false;
    }
    PublicErrorData other = (PublicErrorData) other0;
    return
      publicMessage.equals(other.publicMessage);
  }

  @Override
  public int hashCode() {
    int _result = 1;
    _result = _result * 37 + publicMessage.hashCode();
    return _result;
  }

  /* Factory for construction of generic values */

  public static final Factory<PublicErrorData> FACTORY = new Factory<PublicErrorData>() {
    @Override
    public PublicErrorData create() {
      return new PublicErrorData();
    }

    @Override
    public PublicErrorData create(PublicErrorData other) {
      return new PublicErrorData(other);
    }

    @Override
    public TypeExpr typeExpr() {
      ScopedName scopedName = new ScopedName("common.http", "PublicErrorData");
      ArrayList<TypeExpr> params = new ArrayList<>();
      return new TypeExpr(TypeRef.reference(scopedName), params);
    }
    @Override
    public JsonBinding<PublicErrorData> jsonBinding() {
      return PublicErrorData.jsonBinding();
    }
  };

  /* Json serialization */

  public static JsonBinding<PublicErrorData> jsonBinding() {
    final Lazy<JsonBinding<String>> publicMessage = new Lazy<>(() -> JsonBindings.STRING);
    final Factory<PublicErrorData> _factory = FACTORY;

    return new JsonBinding<PublicErrorData>() {
      @Override
      public Factory<PublicErrorData> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(PublicErrorData _value) {
        JsonObject _result = new JsonObject();
        _result.add("publicMessage", publicMessage.get().toJson(_value.publicMessage));
        return _result;
      }

      @Override
      public PublicErrorData fromJson(JsonElement _json) {
        JsonObject _obj = JsonBindings.objectFromJson(_json);
        return new PublicErrorData(
          JsonBindings.fieldFromJson(_obj, "publicMessage", publicMessage.get())
        );
      }
    };
  }
}
