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

public class MissileId {

  /* Members */

  private String value;

  /* Constructors */

  public MissileId(String value) {
    this.value = Objects.requireNonNull(value);
  }

  public MissileId() {
    this.value = "";
  }

  public MissileId(MissileId other) {
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
    if (!(other0 instanceof MissileId)) {
      return false;
    }
    MissileId other = (MissileId) other0;
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

  public static final Factory<MissileId> FACTORY = new Factory<MissileId>() {
    @Override
    public MissileId create() {
      return new MissileId();
    }

    @Override
    public MissileId create(MissileId other) {
      return new MissileId(other);
    }

    @Override
    public TypeExpr typeExpr() {
      ScopedName scopedName = new ScopedName("canine.api", "MissileId");
      ArrayList<TypeExpr> params = new ArrayList<>();
      return new TypeExpr(TypeRef.reference(scopedName), params);
    }
    @Override
    public JsonBinding<MissileId> jsonBinding() {
      return MissileId.jsonBinding();
    }
  };

  /* Json serialization */

  public static JsonBinding<MissileId> jsonBinding() {
    final JsonBinding<String> _binding = JsonBindings.STRING;
    final Factory<MissileId> _factory = FACTORY;

    return new JsonBinding<MissileId>() {
      @Override
      public Factory<MissileId> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(MissileId _value) {
        return _binding.toJson(_value.value);
      }

      @Override
      public MissileId fromJson(JsonElement _json) {
        return new MissileId(_binding.fromJson(_json));
      }
    };
  }
}
