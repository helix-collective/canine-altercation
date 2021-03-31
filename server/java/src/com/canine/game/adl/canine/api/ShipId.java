/* @generated from adl module canine.api */

package com.canine.game.adl.canine.api;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.adl.runtime.Factories;
import org.adl.runtime.Factory;
import org.adl.runtime.JsonBinding;
import org.adl.runtime.JsonBindings;
import org.adl.runtime.sys.adlast.ScopedName;
import org.adl.runtime.sys.adlast.TypeExpr;
import org.adl.runtime.sys.adlast.TypeRef;
import java.util.ArrayList;
import java.util.Objects;

public class ShipId {

  /* Members */

  private String value;

  /* Constructors */

  public ShipId(String value) {
    this.value = Objects.requireNonNull(value);
  }

  public ShipId() {
    this.value = "";
  }

  public ShipId(ShipId other) {
    this.value = other.value;
  }

  /* Accessors and mutators */

  public String getValue() {
    return value;
  }

  public void setValue(String value) {
    this.value = Objects.requireNonNull(value);
  }

  /* Object level helpers */

  @Override
  public boolean equals(Object other0) {
    if (!(other0 instanceof ShipId)) {
      return false;
    }
    ShipId other = (ShipId) other0;
    return
      value.equals(other.value);
  }

  @Override
  public int hashCode() {
    int _result = 1;
    _result = _result * 37 + value.hashCode();
    return _result;
  }

  /* Factory for construction of generic values */

  public static final Factory<ShipId> FACTORY = new Factory<ShipId>() {
    @Override
    public ShipId create() {
      return new ShipId();
    }

    @Override
    public ShipId create(ShipId other) {
      return new ShipId(other);
    }

    @Override
    public TypeExpr typeExpr() {
      ScopedName scopedName = new ScopedName("canine.api", "ShipId");
      ArrayList<TypeExpr> params = new ArrayList<>();
      return new TypeExpr(TypeRef.reference(scopedName), params);
    }
    @Override
    public JsonBinding<ShipId> jsonBinding() {
      return ShipId.jsonBinding();
    }
  };

  /* Json serialization */

  public static JsonBinding<ShipId> jsonBinding() {
    final JsonBinding<String> _binding = JsonBindings.STRING;
    final Factory<ShipId> _factory = FACTORY;

    return new JsonBinding<ShipId>() {
      @Override
      public Factory<ShipId> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(ShipId _value) {
        return _binding.toJson(_value.value);
      }

      @Override
      public ShipId fromJson(JsonElement _json) {
        return new ShipId(_binding.fromJson(_json));
      }
    };
  }
}
